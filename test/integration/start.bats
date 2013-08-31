#! /usr/bin/env bats

# test starting mcwrapper

setup() {
  export TMP="$BATS_TEST_DIRNAME/tmp"
  export MINECRAFT_SERVER_PATH="$TMP/faux_minecraft_server.jar"
  # export MCWRAPPER_CONFIG_NAME="somegibberishconfignamesowedontbreakshit.conf"
  export mcwrapper="$BATS_TEST_DIRNAME/../../libexec/mcwrapper"
  # export MINECRAFT_SERVER_CMD=bash\ "$MINECRAFT_SERVER_PATH"

  mkdir -p "$TMP"

  cp "$BATS_TEST_DIRNAME/../fixtures/faux_minecraft_server/faux_minecraft_server.jar" "$TMP/"

  pushd "$TMP" &> /dev/null
}

teardown() {
  rm -rf "$TMP"
}

@test "start starts minecraft_server properly" {
  [[ -e "$MINECRAFT_SERVER_PATH" ]]

  $mcwrapper start
  $mcwrapper status
  $mcwrapper stop

  run "$mcwrapper" status
  [[ $status -ne 0 ]]

}

@test "starting up creates pid file" {
  [[ ! -e "$TMP/mcwrapper.pid" ]]

  $mcwrapper start

  # make sure it created the pid
  [[ -f "$TMP/mcwrapper.pid" ]]

  $mcwrapper stop

  # make sure it cleaned up the pid file
  [[ ! -e "$TMP/mcwrapper.pid" ]]
}

@test "start creates and cleans up command pipe" {
  $mcwrapper start

  # make sure command_pipe is a pipe
  [[ -p "$TMP/command_pipe" ]]

  $mcwrapper stop

  # make sure command_pipe is a cleaned up
  [[ ! -e "$TMP/command_pipe" ]]
}
