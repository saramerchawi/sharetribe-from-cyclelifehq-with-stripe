#!/bin/bash

echo "-----------------------------"
echo "-------- CyclelifeHQ --------"
echo "----------- Specs -----------"
echo "-----------------------------"

set -e

echo "----- USER -----"
echo `whoami`
echo "----- Current DIR -----"
echo `pwd`
echo "----- WHICH RUBY -----"
echo `which ruby`


echo "--- bundle install ---"
eval "$(rbenv init -)"
gem install bundler
bundle install

# if ! ruby -v &> /dev/null; then
#   rbenv update
#   rbenv install `cat .ruby-version`
# fi
#
#
# npm install
#
# bundle exec rake db:drop || true
# bundle exec rake db:create
# bundle exec rake db:migrate
#
# bundle exec rspec spec
