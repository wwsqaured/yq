#!/usr/bin/env bash
set -e

# For security, we recommend extracting the api key out as an environment variable in your CI
# https://circleci.com/docs/1.0/environment-variables/#setting-environment-variables-for-all-commands-without-adding-them-to-git
apiKey="$DASHTIC_API_KEY"

name="" # optionally set a name
itemId="$CIRCLE_PROJECT_REPONAME-$CIRCLE_BRANCH"
url="$CIRCLE_BUILD_URL"
description="By $CIRCLE_USERNAME"

function report_failed {
  curl \
    -H "X-Api-Key: $apiKey" \
    -H "Content-Type: application/json" \
    -d "{
    \"itemUri\": \"-L0rXVgD5kjkRUZS4Ta1/-L0rXVpIREppHGSJqQcY/cicd/$itemId\",
    \"itemContents\": {
      \"name\": \"$name\",
      \"url\": \"$url\",
      \"description\": \"$description\",
      \"failed\": $1
    }
  }" https://daas-staging.firebaseapp.com/api/update-item
}

trap "report_failed true" ERR

./scripts/devtools.sh
make local test

report_failed false