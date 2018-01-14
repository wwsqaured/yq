#!/usr/bin/env bash
set -e

# For security, we recommend extracting the api key out as an environment variable in your CI
# https://circleci.com/docs/1.0/environment-variables/#setting-environment-variables-for-all-commands-without-adding-them-to-git
apiKey="$DASHTIC_API_KEY"

repo="$CIRCLE_PROJECT_REPONAME"
branch="$CIRCLE_BRANCH"
name="$repo ($branch)" # optionally set a name
itemId="$repo-$branch"
url="$CIRCLE_BUILD_URL"
description="By $CIRCLE_USERNAME"

function report_failed {
  curl \
    -H "X-Api-Key: $apiKey" \
    -H "Content-Type: application/json" \
    -d "{
    \"itemUri\": \"-L0rXVgD5kjkRUZS4Ta1/-L2cvVcWYA4CNmwL7F3o/cicd/$itemId\",
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