#!/bin/bash

set -e

echo "--- deploying to staging"
git push heroku master -a cyclelifehq-staging
