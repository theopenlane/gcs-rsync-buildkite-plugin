setup() {
  export HOOK="$(dirname "$BATS_TEST_DIRNAME")/hooks/command"
  export DOCKER_CMD="$BATS_TMPDIR/docker_cmd"
  mkdir -p "$BATS_TMPDIR"
  cat <<'EOH' > "$BATS_TMPDIR/docker"
#!/usr/bin/env bash
printf "%s\n" "$@" > "$DOCKER_CMD"
EOH
  chmod +x "$BATS_TMPDIR/docker"
  PATH="$BATS_TMPDIR:$PATH"
}
