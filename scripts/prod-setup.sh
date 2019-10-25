#!/bin/bash

cd `dirname "$0"`/..

# Settings that might need to change

ADMIN_USER=root
DEPLOY_HOST=web8.cs.ait.ac.th
DEPLOY_HOST_SSH_PORT=22

# Settings that might not need to change

DEPLOY_USER=deploy
PROJECT_REPO=web19-08
PROXY="http://192.41.170.23:3128"
PROD_DB="problem_sets_production"
PROD_DB_USER="problem_sets"
SSL_EMAIL=st120832@ait.ac.th

# Different settings for staging vs production

if [ "$SERVER_ENVIRONMENT" == "staging" ]; then
	echo "Staging!"
	echo "Under Construction! Please come back later!"
	exit 1
else
	echo "Production!"
	DEPLOY_HOST=web8.cs.ait.ac.th
  	DEPLOY_HOST_SSH_PORT=22
  	ADMIN_USER=root
  	SSH_KEYS=(~/.ssh/id_rsa)
  	SSH_OPTS=""
fi

if [ -z "$BAZOOKA_USER" ] ; then
  echo "Error: you need to set a bazooka user for csim proxy."
  echo 'Run "export BAZOOKA_USER=st12345" to set a password.'
  exit 1
fi

if [ -z "$PROD_DB_PASSWORD" ] ; then
  echo "Error: you need a production database password."
  echo 'Run "export PROD_DB_PASSWORD=mysecret" to set a password.'
  exit 1
fi

if [ -z "$MASTER_KEY" ] ; then
  echo "Error: you need a master key for the production server."
  echo 'Run "export MASTER_KEY=`cat config/master.key`" to set a key.'
  exit 1
fi

### SSH_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1rrlSiTDT9WupW/7kUf13j90njBoAjKZjfvs4K8dU1RM/l6NSCP3NcAJYPajEd6rRmbgQmz0Jh6UfddF9vk3++bcvkyHKeIzGUy5tbagRV/5TeYg16IJ5/kxV2mmoahHFD7GAeHAGrtTcF1+PK0ZPyP4nqdcRS34CS+XfSbOBvD6+K6855q/J7ywl3qQZa50gjVw0CWazEuyfwF5GgmOb471OY/iwPKfwgK/UpbtcK6n3H8AHVPEJ0S9jO5wiEw/MoVDAv40BiWcaStXnmiVPKTgRde6zOAa8fPp21OObhqhClGWOe924bzOFzBJR6CRSn4bkVzmHSq2JiX6FWTv7 adam@adam-X556UQK"

if [ -z "$SSH_PUBLIC_KEY" ] ; then
  echo "Error: you need to export your PUBLIC ssh key."
  echo 'Run "export SSH_PUBLIC_KEY=`cat ~/.ssh/key.pub`" to set a public key.'
  exit 1
fi

#echo $SSH_PUBLIC_KEY
#exit 1

# Add git keys to ssh agent

if [ ! -z "$SSH_AGENT_PID" ] ; then
  echo "Have ssh-agent PID: $SSH_AGENT_PID"
  ps $SSH_AGENT_PID > /dev/null
  STATUS=$?
  if [ $STATUS -ne 0 ] ; then
    echo "But it's not valid"
    SSH_AGENT_PID=
  fi
fi
if [ -z "$SSH_AGENT_PID" ] ; then
  echo 'You need to run ssh-agent. Please run "eval `ssh-agent`" first."'
  exit 1
fi
for KEY in "${SSH_KEYS[@]}" ; do
  echo "Checking key $KEY"
  ssh-add -L | grep $KEY > /dev/null || {
    echo "Key $KEY not available"
    ssh-add $KEY
  }
done

echo "SSH to $DEPLOY_HOST WITH $ADMIN_USER..."
ssh $SSH_OPTS -T $ADMIN_USER@$DEPLOY_HOST -p $DEPLOY_HOST_SSH_PORT /bin/bash <<EOF
  echo "Installing packages..."
  sudo apt-get -y install apache2 curl dirmngr gnupg unattended-upgrades \
            software-properties-common > /dev/null
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
               --keyserver-options http-proxy=http://192.41.170.23:3128 \
               --recv-keys 561F9B9CAC40B2F7 > /dev/null 2>&1
  sudo apt-get install -y apt-transport-https ca-certificates > /dev/null
  sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
  sudo add-apt-repository universe > /dev/null
  https_proxy=${PROXY} sudo -E add-apt-repository ppa:certbot/certbot > /dev/null
  sudo apt-get update > /dev/null
  sudo apt-get install -y libapache2-mod-passenger certbot \
                          python-certbot-apache > /dev/null
  sudo apt-get -y upgrade > /dev/null
  echo "Setting up deploy user..."
  grep ^${DEPLOY_USER}: /etc/passwd > /dev/null || {
    sudo adduser --gecos "" --disabled-password $DEPLOY_USER
  }
  mkdir -p /home/$DEPLOY_USER/.ssh

  echo ${SSH_PUBLIC_KEY} > /home/${DEPLOY_USER}/.ssh/authorized_keys

  chown -R ${DEPLOY_USER}:${DEPLOY_USER} /home/${DEPLOY_USER}
  if [ ! -f "/etc/apt/sources.list.d/nodesource.list" ] ; then
    echo "Adding nodejs repository..."
    export HTTPS_PROXY=${PROXY}
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update
  fi
  echo "Installing packages required for rbenv/rails..."
  sudo apt install -y nodejs yarn build-essential libpq-dev \
                      libreadline-dev libssl-dev zlib1g-dev \
                      libyaml-dev nodejs postgresql > /dev/null 2>&1
  # Create postgres user PROD_DB_USER if it doesn't already exist
  # From https://stackoverflow.com/questions/8546759/
  # how-to-check-if-a-postgres-user-exists
  echo "Checking existence of production database user..."
  PGCMD="SELECT 1 FROM pg_roles WHERE rolname='${PROD_DB_USER}'"
  su - postgres -c "psql postgres -tAc \"\${PGCMD}\" " | grep -q 1 && {
    echo "PG user $PROD_DB_USER already exists"
  } || {
    echo "PG user $PROD_DB_USER does not yet exist. Creating..."
    su - postgres -c "createuser $PROD_DB_USER"
  }
  echo "Checking existence of production database..."
  su - postgres -c "psql $PROD_DB -c \"\"" > /dev/null 2>&1 && {
    echo "Success accessing db $PROD_DB"
  } || {
    echo "Database $PROD_DB does not exist. Creating..."
    su - postgres -c "createdb $PROD_DB -O $PROD_DB_USER" || {
      echo "Postgres database creation failed!"
    }
  }
  echo "Setting db password for $PROD_DB_USER"
  PGCMD="alter user problem_sets with password '${PROD_DB_PASSWORD}'";
  su - postgres -c "psql postgres -Ac \"\${PGCMD}\" " && {
    echo "Postgres user password set."
  } || {
    echo "Postgres user password setup failed!"
  }
  
  if [ ! -f /etc/apache2/sites-enabled/rails.conf ] ; then
    echo "Setting up Apache..."
    a2enmod passenger
    cat > /etc/apache2/sites-available/rails.conf <<EOF2
<VirtualHost *:80>
  ServerName web1.cs.ait.ac.th

  SetEnv http_proxy http://192.41.170.23:3128/
  SetEnv https_proxy http://192.41.170.23:3128/
  SetEnv PROBLEM_SETS_DATABASE_PASSWORD changeme

  # Tell Apache and Passenger where your app's 'public' directory is
  DocumentRoot /home/deploy/problem-sets/current/public

  PassengerRuby /home/deploy/.rbenv/shims/ruby

  # Relax Apache security settings
  <Directory /home/deploy/problem-sets/current/public>
    Allow from all
    Options -MultiViews
    Require all granted
  </Directory>
</VirtualHost>
EOF2
    a2dissite 000-default > /dev/null
    a2ensite test-app > /dev/null
    rm -f /var/www/html/index.html
    apache2ctl restart
  else
    echo "Apache, Passenger, Certbot already configured..."
    apache2ctl restart
  fi
EOF

# Log in as deploy user, set up git, and check out project repository

ssh $SSH_OPTS -T $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_HOST_SSH_PORT /bin/bash <<EOF
  if [ ! -f /home/${DEPLOY_USER}/.ssh/known_hosts ] ; then
    touch /home/${DEPLOY_USER}/.ssh/known_hosts
  fi

  grep 9cIYXOiLOOn7Uhx7ALShiVT8UPU= /home/${DEPLOY_USER}/.ssh/known_hosts || {
  echo '|1|9cIYXOiLOOn7Uhx7ALShiVT8UPU=|EV5uNqCzTTpAdPUGyBg8pdY7bX4= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBATD2SHAffLfw42QH9dniwoT0xIPN2vf4gycNlr+rTexmwsam+c4LyTfZJt83WsF30LYVsxJxMubzui3oeLfOSQ=' >> /home/${DEPLOY_USER}/.ssh/known_hosts
  }

  grep eQ3jZ4GB3rgwhSlcwzQ4K7ioawY= /home/${DEPLOY_USER}/.ssh/known_hosts || {
  echo '|1|eQ3jZ4GB3rgwhSlcwzQ4K7ioawY=|dNCnM1ekzo4huaD5a0X55x8/WZQ= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLBbZrwQNbRQfgily2GtVjLz5DrIauDv88r2JA/F/AvTFD20fVOarQwfqUeLuR5kXsZDe4qtj/P05veH539JtZA=' >> /home/${DEPLOY_USER}/.ssh/known_hosts
  }

  
  if [ ! -f /home/${DEPLOY_USER}/.ssh/config ] ; then
    cat > /home/${DEPLOY_USER}/.ssh/config <<'EOF2'
Host ait-vision.org
  ProxyCommand ssh \${BAZOOKA_USER}@bazooka.cs.ait.ac.th nc %h %p
  ForwardAgent yes
EOF2
  fi

  export BAZOOKA_USER=${BAZOOKA_USER}
  if [ ! -d /home/${DEPLOY_USER}/${PROJECT_REPO} ] ; then
    git clone git@ait-vision.org:${PROJECT_REPO}
  fi

  cd ${PROJECT_REPO}
  git pull origin master
  mkdir -p ~/problem-sets/shared/config

  cat > ~/problem-sets/shared/config/database.yml <<EOF2
production:
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  database: ${PROD_DB}
  host: localhost
  username: ${PROD_DB_USER}
  password: ${PROD_DB_PASSWORD}
EOF2
  echo "Checking for production database access..."
  PGPASSWORD=${PROD_DB_PASSWORD} psql ${PROD_DB} -U ${PROD_DB_USER} -h localhost -c "" && {
    echo "Successful connection."
  } || {
    echo "Deploy user cannot authenticate against production database!"
    exit 1
  }
  echo "Setting master.key"
  echo "${MASTER_KEY}" > ~/problem-sets/shared/config/master.key
EOF
