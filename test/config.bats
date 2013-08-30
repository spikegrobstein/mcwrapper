#! /usr/bin/env bats

load test_helper

# default config

@test "default_config sets MINECRAFT_SERVER_PATH if it's not set" {
  [ -z "$MINECRAFT_SERVER_PATH" ]
  init_mcwrapper
  default_config
  [ ! -z "$MINECRAFT_SERVER_PATH" ]
}

@test "default_config doesn't change MINECRAFT_SERVER_PATH if it's set" {
  EXPLICIT_PATH=$(fixture_path 'minecraft_server.jar')
  MINECRAFT_SERVER_PATH=$EXPLICIT_PATH
  init_mcwrapper
  default_config
  [ "$MINECRAFT_SERVER_PATH" = "$EXPLICIT_PATH" ]
}

# process config
@test "process_config returns 1 if MINECRAFT_SERVER_PATH is not set" {
  unset MINECRAFT_SERVER_PATH
  init_mcwrapper
  run process_config
  [ "$status" -eq 1 ]
}

@test "process_config sets PID_FILE to absolute path if it's relative" {
  MINECRAFT_SERVER_PATH=$(fixture_path 'minecraft_server.jar')
  OLD_PID_FILE="mcwrapper.pid"
  PID_FILE=$OLD_PID_FILE
  init_mcwrapper
  process_config

  [ "$PID_FILE" != "$OLD_PID_FILE" ]
}

@test "process_config does not touch PID_FILE if it's an absolute path" {
  MINECRAFT_SERVER_PATH=$(fixture_path 'minecraft_server.jar')
  OLD_PID_FILE="/path/to/mcwrapper.pid"
  PID_FILE=$OLD_PID_FILE
  init_mcwrapper
  process_config

  [ "$PID_FILE" = "$OLD_PID_FILE" ]
}

# read config

