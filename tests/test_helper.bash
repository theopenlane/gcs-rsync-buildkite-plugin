setup() {
  export HOOK="$(dirname "$BATS_TEST_DIRNAME")/hooks/command"
  export PRE_HOOK="$(dirname "$BATS_TEST_DIRNAME")/hooks/pre-command"
  export DOCKER_CMD="$BATS_TMPDIR/docker_cmd"
  mkdir -p "$BATS_TMPDIR/bin"
  cat <<'EOH' > "$BATS_TMPDIR/bin/docker"
#!/usr/bin/env bash
printf "%s\n" "$@" > "$DOCKER_CMD"
EOH
  chmod +x "$BATS_TMPDIR/bin/docker"

  cat <<'EOH' > "$BATS_TMPDIR/bin/buildkite-agent"
#!/usr/bin/env bash
if [[ "$1" == "oidc" && "$2" == "request-token" ]]; then
  echo "meow"
else
  echo "unknown command" >&2
  exit 1
fi
EOH
  chmod +x "$BATS_TMPDIR/bin/buildkite-agent"
  PATH="$BATS_TMPDIR/bin:$PATH"
  export BUILDKITE_REPO="git@github.com:theopenlane/test-repo.git"
}
