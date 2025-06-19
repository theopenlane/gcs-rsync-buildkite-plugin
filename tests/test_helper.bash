setup() {
  export HOOK="$(dirname "$BATS_TEST_DIRNAME")/hooks/command"
  export DOCKER_CMD="$BATS_TMPDIR/docker_cmd"
  mkdir -p "$BATS_TMPDIR/bin"
  cat <<'EOH' > "$BATS_TMPDIR/bin/docker"
#!/usr/bin/env bash
printf "%s\n" "$@" > "$DOCKER_CMD"
EOH
  chmod +x "$BATS_TMPDIR/bin/docker"
  PATH="$BATS_TMPDIR/bin:$PATH"
}
