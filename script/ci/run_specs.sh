#!/bin/bash

echo "-----------------------------"
echo "-------- CyclelifeHQ --------"
echo "----------- Specs -----------"
echo "-----------------------------"

set -e

echo "--- agent setup"
eval "$(rbenv init -)"
gem install bundler

echo "--- bundle install"
bundle install

echo "--- ruby version check"
if ! ruby -v &> /dev/null; then
  rbenv update
  rbenv install `cat .ruby-version`
fi

echo "--- setup database"
cp config/database.example.yml config/database.yml
bundle exec rake db:drop || true
bundle exec rake db:create
bundle exec rake db:schema:load

echo "--- running specs"
bundle exec rspec spec
