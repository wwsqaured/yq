#!/usr/bin/env bash
set -e

# For security, we recommend extracting the api key out as an environment variable in your CI
# https://docs.gocd.org/current/faq/environment_variables.html
apiKey="abc123-abc123-abc123"

itemId="$GO_PIPELINE_NAME-$GO_JOB_NAME"
url=""
description="$GO_STAGE_NAME"

function report_failed {
  curl -v \
    -H "X-Api-Key: $apiKey" \
    -H "Content-Type: application/json" \
    -d "{
    \"itemUri\": \"accountId/dashboardId/boxId/$itemId\",
    \"itemContents\": {
      \"url\": \"$url\",
      \"description\": \"$description\",
      \"failed\": $1
    }
  }" http://localhost:3000/api/update-item
}

trap "report_failed true" ERR

echo "TODO: build script goes here"

report_failed false