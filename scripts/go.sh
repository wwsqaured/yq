#!/usr/bin/env bash
set -e

# For security, we recommend extracting the api key out as an environment variable in your CI
# https://docs.gocd.org/current/faq/environment_variables.html
apiKey="$DASHTIC_API_KEY"

repo="$GO_PIPELINE_NAME-$GO_JOB_NAME"

name="$repo" # optionally set a name
itemId="$repo"
url=""
description="$GO_STAGE_NAME"

function report_failed {
  curl \
    -H "X-Api-Key: $apiKey" \
    -H "Content-Type: application/json" \
    -d "{
    \"itemUri\": \"-L2cyF1pYaFXX43o3c-B/-L2cyF0kR4SYk7iFu4ii/cicd/$itemId\",
    \"itemContents\": {
      \"name\": \"$name\",
      \"url\": \"$url\",
      \"description\": \"$description\",
      \"failed\": $1
    }
  }" https://dashtic.com/api/update-item
}


trap "report_failed true" ERR

env

echo 'great'

report_failed false

