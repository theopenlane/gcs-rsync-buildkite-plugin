#!/usr/bin/env bats

load "test_helper.bash"

@test "fails without bucket" {
  run "$HOOK"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required configuration"* ]]
}

@test "invokes gsutil rsync in docker" {
  export BUILDKITE_PLUGIN_GCS_RSYNC_BUCKET="my-bucket"
  export BUILDKITE_PLUGIN_GCS_RSYNC_SOURCE="templates"
  export BUILDKITE_PLUGIN_GCS_RSYNC_SERVICE_ACCOUNT_KEY='{}'

  run "$HOOK"
  [ "$status" -eq 0 ]
  grep -q "gsutil -m rsync" "$DOCKER_CMD"
  grep -q "templates" "$DOCKER_CMD"
  grep -q "my-bucket" "$DOCKER_CMD"
}
