#! /usr/bin/env bats

load test_helper

setup() {
  init_mcwrapper
}

@test "read_server_property errors if SERVER_PROPERTIES_PATH does not exist" {
  unset SERVER_PROPERTIES_PATH
  run read_server_property
  [ "$status" -eq $EXIT_NO_SERVER_PROPERTIES ]
}


