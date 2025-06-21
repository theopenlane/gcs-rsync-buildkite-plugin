#!/usr/bin/env bats

load "test_helper.bash"

@test "fails without bucket" {
  run "$HOOK" 2>&1
  echo "status: $status"
  echo "output: $output"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required configuration"* ]]
}

@test "invokes gsutil rsync in docker" {
  export BUILDKITE_PLUGIN_GCS_RSYNC_BUCKET="my-bucket"
  export BUILDKITE_PLUGIN_GCS_RSYNC_SOURCE="templates"
  export BUILDKITE_PLUGIN_GCS_RSYNC_PROJECT="my-project"
  export BUILDKITE_PLUGIN_GCS_RSYNC_PROJECT_NUMBER="123456789"
  export BUILDKITE_PLUGIN_GCS_RSYNC_POOL_ID="my-pool"
  export BUILDKITE_PLUGIN_GCS_RSYNC_SERVICE_ACCOUNT="sa@example.com"
  export BUILDKITE_PLUGIN_GCS_RSYNC_PROVIDER_ID="custom-provider"

  source "$PRE_HOOK"
  grep -q "providers/custom-provider" "$DOCKER_CMD"

  run "$HOOK" 2>&1
  echo "status: $status"
  echo "output: $output"
  [ "$status" -eq 0 ]
  grep -q "gsutil -m rsync" "$DOCKER_CMD"
  grep -q "templates" "$DOCKER_CMD"
  grep -q "my-bucket" "$DOCKER_CMD"
}
