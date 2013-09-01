#! /usr/bin/env bats

# test starting mcwrapper

setup() {
  export TMP="$BATS_TEST_DIRNAME/tmp"
  export MINECRAFT_SERVER_PATH="$TMP/faux_minecraft_server.jar"
  export PID_FILE="$TMP/mcwrapper.pid"
  export COMMAND_PIPE="$TMP/command_input"

  export PATH="$BATS_TEST_DIRNAME/../libexec:${PATH}"
  # export mcwrapper="$BATS_TEST_DIRNAME/../../libexec/mcwrapper"

  mkdir -p "$TMP"

  cp "$BATS_TEST_DIRNAME/fixtures/faux_minecraft_server/faux_minecraft_server.jar" "$TMP/"

  pushd "$TMP" &> /dev/null
}

teardown() {
  rm -rf "$TMP"
}

@test "start starts minecraft_server properly" {
  [ -e "$MINECRAFT_SERVER_PATH" ]

  mcwrapper start
  mcwrapper status
  mcwrapper stop

  run mcwrapper status
  [ $status -ne 0 ]
}

@test "starting up creates and cleans up pid file" {
  [ ! -e "$PID_FILE" ]

  mcwrapper start

  # make sure it created the pid
  [ -f "$PID_FILE" ]

  mcwrapper stop

  sleep 2

  # make sure it cleaned up the pid file
  [ ! -e "$PID_FILE" ]
}

@test "start creates and cleans up command pipe" {
  [ ! -e "$COMMAND_PIPE" ]

  mcwrapper start

  # make sure command_pipe is a pipe
  [ -p "$COMMAND_PIPE" ]

  mcwrapper stop

  sleep 2

  # make sure command_pipe is a cleaned up
  [ ! -e "$COMMAND_PIPE" ]
}

