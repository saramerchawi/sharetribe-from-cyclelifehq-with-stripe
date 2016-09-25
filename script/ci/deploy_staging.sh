#!/bin/bash

set -e

echo "--- deploying to staging"
git push heroku "$BUILDKITE_COMMIT":master --app cyclelifehq-staging
