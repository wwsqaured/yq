#!/usr/bin/env bash
set -e

# For security, we recommend extracting the api key out as an environment variable in your CI
# https://docs.travis-ci.com/user/environment-variables/#Defining-encrypted-variables-in-.travis.yml
apiKey=$DASHTIC_API

name="YQ Travis" # optionally set a name
itemId="$TRAVIS_REPO_SLUG-$TRAVIS_BRANCH"
url="https://travis-ci.org/$TRAVIS_REPO_SLUG/builds/$TRAVIS_BUILD_NUMBER"
description="$TRAVIS_COMMIT_MESSAGE"

function report_failed {
  curl \
    -H "X-Api-Key: $apiKey" \
    -H "Content-Type: application/json" \
    -d "{
    \"itemUri\": \"-L0rXVgD5kjkRUZS4Ta1/-L2cvVcWYA4CNmwL7F3o/test/$itemId\",
    \"itemContents\": {
      \"name\": \"$name\",
      \"url\": \"$url\",
      \"description\": \"$description\",
      \"failed\": $1
    }
  }" https://daas-staging.firebaseapp.com/api/update-item
}

trap "report_failed true" ERR

fail


report_failed false