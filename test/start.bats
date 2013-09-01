#! /usr/bin/env bats

# test starting mcwrapper

load test_helper

setup() {
  set_path
  set_tmp
  set_faux_server
  export PID_FILE="$TMP/mcwrapper.pid"
  export COMMAND_PIPE="$TMP/command_input"
}

teardown() {
  rm_tmp
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

