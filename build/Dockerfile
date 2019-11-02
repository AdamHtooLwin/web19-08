FROM ruby:2.6.3

ENV http_proxy http://192.41.170.23:3128/
ENV https_proxy http://192.41.170.23:3128/

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev \
            postgresql sudo curl

RUN curl -sL https://deb.nodesource.com/setup_10.x | \
    bash - && apt-get install -y nodejs
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

RUN groupadd -g 1000 jenkins
RUN useradd -r -u 1000 -g jenkins jenkins

RUN usermod -a -G sudo jenkins
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/jenkins
RUN chown -R jenkins /home/jenkins

USER jenkins

