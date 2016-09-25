#!/bin/bash

set -e

echo "--- deploying to staging"
git push -f heroku-staging "$BUILDKITE_COMMIT":master
