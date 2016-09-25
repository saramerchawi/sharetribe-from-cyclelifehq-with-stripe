#!/bin/bash

set -e
set -x

git reset --hard

echo "--- checking out branch"
git checkout staging
git reset --hard origin/staging

echo "--- merging master into staging"
git fetch -p origin
git merge origin/master --no-ff

echo "--- pushing changes to github"
# this will kick off a build for staging
git push origin staging:staging
