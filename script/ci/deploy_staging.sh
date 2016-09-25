#!/bin/bash

set -e

echo "--- deploying to staging"
git push heroku-staging "$BUILDKITE_COMMIT":master
