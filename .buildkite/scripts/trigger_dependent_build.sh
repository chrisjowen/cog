#!/usr/bin/env bash

set -euo pipefail

DEPENDENT_PROJECT=${1}
TRIGGER_PIPELINE_SLUG=${DEPENDENT_PROJECT}

if git ls-remote --exit-code --heads https://github.com/operable/$DEPENDENT_PROJECT refs/heads/${BUILDKITE_BRANCH} > /dev/null 2>&1
then
    TRIGGER_BRANCH=${BUILDKITE_BRANCH}
else
    TRIGGER_BRANCH='master'
fi

TRIGGER_MESSAGE=":cogops: Dependent Build Triggered from ${BUILDKITE_BUILD_URL} :cogops:"

curl \
  "https://api.buildkite.com/v2/organizations/${BUILDKITE_ORGANIZATION_SLUG}/pipelines/${TRIGGER_PIPELINE_SLUG}/builds" \
  --request POST \
  --fail \
  --header "Authorization: Bearer ${BUILDKITE_API_ACCESS_TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{
    \"commit\": \"HEAD\",
    \"branch\": \"${TRIGGER_BRANCH}\",
    \"message\": \"${TRIGGER_MESSAGE}\",
    \"env\": {
      \"COG_BRANCH\": \"${BUILDKITE_BRANCH}\"
    }
  }"
