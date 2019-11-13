#!/bin/bash

# Find the test-app directory

cd `dirname "$0"`/..
PROJECT_DIR="`pwd`"

cd problem-sets
## yarn install --check-files
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake test

