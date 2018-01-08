#!/usr/bin/env bash
set -e

apiKey="$DASHTIC_API_KEY"

itemId="$CIRCLE_PROJECT_REPONAME-$CIRCLE_BRANCH"
url="$CIRCLE_BUILD_URL"
description="By $CIRCLE_USERNAME"

function report_failed {
  curl -v \
    -H "X-Api-Key: $apiKey" \
    -H "Content-Type: application/json" \
    -d "{
    \"itemUri\": \"-L0rXVgD5kjkRUZS4Ta1/-L0rXVpIREppHGSJqQcY/cicd/$itemId\",
    \"itemContents\": {
      \"name\": \"$CIRCLE_PROJECT_REPONAME ($CIRCLE_BRANCH)\",
      \"url\": \"$url\",
      \"description\": \"$description\",
      \"failed\": $1
    }
  }" https://daas-staging.firebaseapp.com/api/update-item
}

trap "report_failed true" ERR
fail
./scripts/devtools.sh
make local test

report_failed false
