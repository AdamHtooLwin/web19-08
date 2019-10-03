#!/bin/bash

cd `dirname "$0"`/..

# Settings that might need to change

if [ "$SERVER_ENVIRONMENT" == "staging" ]; then
  echo "Staging!"
  DEPLOY_HOST=localhost
  DEPLOY_HOST_SSH_PORT=2222
  ADMIN_USER=vagrant
  vagrant box list | grep ubuntu/bionic64 || {
    vagrant box add ubuntu/bionic64
  }
  if [ ! -f "./Vagrantfile" ]; then
    vagrant init ubuntu/bionic64
  fi
  vagrant destroy -f default
  vagrant up
  SSH_KEYS=(~/.ssh/mdailey@ait.ac.th_rsa ~/.ssh/id_rsa ./.vagrant/machines/default/virtualbox/private_key)
  SSH_OPTS="-o StrictHostKeyChecking=no"
  ssh-keygen -R [localhost]:2222
else
  echo "Production!"
  DEPLOY_HOST=web1.cs.ait.ac.th
  DEPLOY_HOST_SSH_PORT=22
  ADMIN_USER=root
  SSH_KEYS=(~/.ssh/mdailey@ait.ac.th_rsa ~/.ssh/id_rsa)
  SSH_OPTS=""
fi

ssh-add -D

DEPLOY_USER=deploy
PROJECT_REPO=web19-01
BAZOOKA_USER=mdailey
PROXY="http://192.41.170.23:3128"
PROD_DB="test_app_production"
PROD_DB_USER="test_app"

# Check that we have $PROD_DB_PASSWORD and $MASTER_KEY

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

# Install needed packages

ssh $SSH_OPTS -T $ADMIN_USER@$DEPLOY_HOST -p $DEPLOY_HOST_SSH_PORT /bin/bash <<EOF
  echo "Installing packages..."
  sudo apt-get -y upgrade > /dev/null
  sudo apt-get -y install apache2 curl > /dev/null
  echo "Setting up deploy user..."
  grep ^${DEPLOY_USER}: /etc/passwd > /dev/null || {
    sudo adduser --gecos "" --disabled-password $DEPLOY_USER
  }
  mkdir -p /home/$DEPLOY_USER/.ssh
  echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxa6F6trAUZl9RGIpxrioaBtZdlg01XV5V+w/kvg+sStwFI2j8VNbq3nmwfAmjyxAn3uwHH1oaIxx+k4CcunubED70BIFG+j7q0zpKf728fRiy8OWWg5NodnlLQ81MQkaALR3105r9k8vD49ZcxAsf/EQ/cI9Gi6kRQyOzEFiCS0ebp0Tg/beea5/lz6KJxIlsVA/jYSIyFHsGksanmIFtXyoBWa293z9DPFIFNRr09o+09uiTzvwVrnkPi+h9TO33bTKhX5pk72H1hMv1UHL1kmyWyu73QRNzPJlrHw+cZYYLTCI8uobrAxBpbXilSsx8o1pwJLQLOAYw7mniTx1cw== mdailey@mdailey-t" > /home/${DEPLOY_USER}/.ssh/authorized_keys
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
  PGCMD="alter user test_app with password '${PROD_DB_PASSWORD}'";
  su - postgres -c "psql postgres -Ac \"\${PGCMD}\" " && {
    echo "Postgres user password set."
  } || {
    echo "Postgres user password setup failed!"
  }
EOF

echo "Done with DB setup"

# Log in as deploy user, set up git, and check out project repository

ssh $SSH_OPTS -T $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_HOST_SSH_PORT /bin/bash <<EOF
  if [ ! -f /home/${DEPLOY_USER}/.ssh/known_hosts ] ; then
    touch /home/${DEPLOY_USER}/.ssh/known_hosts
  fi
  grep ayOwPvCsbYATrWmRvCTaR0YRuEI= /home/${DEPLOY_USER}/.ssh/known_hosts || {
    echo '|1|ayOwPvCsbYATrWmRvCTaR0YRuEI=|pNmneXdn9DKx1qVGtBFNIKVlc20= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBATD2SHAffLfw42QH9dniwoT0xIPN2vf4gycNlr+rTexmwsam+c4LyTfZJt83WsF30LYVsxJxMubzui3oeLfOSQ=' >> /home/${DEPLOY_USER}/.ssh/known_hosts
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
  mkdir -p ~/test-app/shared/config
  cat > ~/test-app/shared/config/database.yml <<EOF2
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
  echo "${MASTER_KEY}" > ~/test-app/shared/config/master.key
EOF

