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

@test "process_config sets COMMAND_PIPE to absolute path if it's relative" {
  MINECRAFT_SERVER_PATH=$(fixture_path 'minecraft_server.jar')
  OLD_COMMAND_PIPE="mcwrapper.pid"
  COMMAND_PIPE=$OLD_COMMAND_PIPE
  init_mcwrapper
  process_config

  [ "$COMMAND_PIPE" != "$OLD_COMMAND_PIPE" ]
}

@test "process_config does not touch COMMAND_PIPE if it's an absolute path" {
  MINECRAFT_SERVER_PATH=$(fixture_path 'minecraft_server.jar')
  OLD_COMMAND_PIPE="/path/to/mcwrapper.pid"
  COMMAND_PIPE=$OLD_COMMAND_PIPE
  init_mcwrapper
  process_config

  [ "$COMMAND_PIPE" = "$OLD_COMMAND_PIPE" ]
}

@test "process_config sets MINECRAFT_SERVER_CMD if it's not set" {
  MINECRAFT_SERVER_PATH=$(fixture_path 'minecraft_server.jar')
  [ -z "$MINECRAFT_SERVER_CMD" ]
  init_mcwrapper
  process_config
  [ ! -z "$MINECRAFT_SERVER_CMD" ]
}

@test "process_config does not override existing MINECRAFT_SERVER_CMD" {
  MINECRAFT_SERVER_PATH=$(fixture_path 'minecraft_server.jar')
  OLD_MINECRAFT_SERVER_CMD="some_command"
  MINECRAFT_SERVER_CMD=$OLD_MINECRAFT_SERVER_CMD

  init_mcwrapper
  process_config

  [ "$OLD_MINECRAFT_SERVER_CMD" = "$MINECRAFT_SERVER_CMD" ]
}

@test "process_config sets SERVER_PROPERTIES_PATH" {
  MINECRAFT_SERVER_PATH=$(fixture_path 'minecraft_server.jar')
  init_mcwrapper
  process_config

  [ ! -z "$SERVER_PROPERTIES_PATH" ]
}

@test "process_config does not override existing SERVER_PROPERTIES_PATH" {
  MINECRAFT_SERVER_PATH=$(fixture_path 'minecraft_server.jar')
  OLD_SERVER_PROPERTIES_PATH="some_path"
  SERVER_PROPERTIES_PATH=$OLD_SERVER_PROPERTIES_PATH

  init_mcwrapper
  process_config

  [ "$OLD_SERVER_PROPERTIES_PATH" = "$SERVER_PROPERTIES_PATH" ]
}

@test "process_config sets BACKUP_DIRECTORY_PATH to absolute if it's relative" {
  MINECRAFT_SERVER_PATH=$(fixture_path 'minecraft_server.jar')
  OLD_BACKUP_DIRECTORY_PATH="backup"
  BACKUP_DIRECTORY_PATH=$OLD_BACKUP_DIRECTORY_PATH

  init_mcwrapper
  process_config

  # TODO: add test to see if it's actually absolute and contains old value
  [ "$OLD_BACKUP_DIRECTORY_PATH" != "$BACKUP_DIRECTORY_PATH" ]
}

@test "process_config does not touch BACKUP_DIRECTORY_PATH if it's absolute" {
  MINECRAFT_SERVER_PATH=$(fixture_path 'minecraft_server.jar')
  OLD_BACKUP_DIRECTORY_PATH="/path/to/backups"
  BACKUP_DIRECTORY_PATH=$OLD_BACKUP_DIRECTORY_PATH

  init_mcwrapper
  process_config

  [ "$OLD_BACKUP_DIRECTORY_PATH" = "$BACKUP_DIRECTORY_PATH" ]
}

# read config

