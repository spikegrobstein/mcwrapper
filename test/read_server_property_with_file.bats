#! /usr/bin/env bats

load test_helper

setup() {
  init_mcwrapper
  SERVER_PROPERTIES_PATH=$( fixture_path server.properties )
}

@test "read_server_property returns all of file's keys if PROP_NAME is not passed" {
  [ $( read_server_property | wc -l ) == 26 ]
}

@test "read_server_property does not return any commented lines if no PROP_NAME is passed" {
  run read_server_property "allow-flight"

  [ -z "$output" ]
}

@test "read_server_property returns the value of the given server property" {
  run read_server_property "motd"

  [ "$output" = "A Minecraft Server" ]
}
