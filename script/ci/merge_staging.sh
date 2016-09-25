#!/bin/bash

set -e

git reset --hard

echo "--- checking out branch"
git checkout staging
git reset --hard

echo "--- merging master into staging"
git fetch -p origin
git merge origin/master --no-ff -m "Merging master into staging"

echo "--- pushing changes to github"
# this will kick off a build for staging
git push origin staging:staging
