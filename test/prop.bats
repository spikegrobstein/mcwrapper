#! /usr/bin/env bats

load test_helper

init_mcwrapper

@test "read_server_property errors if SERVER_PROPERTIES_PATH does not exist" {
  unset SERVER_PROPERTIES_PATH
  run read_server_property
  [ "$status" -eq $EXIT_NO_SERVER_PROPERTIES ]
}

@test "read_server_property returns all of file's keys if PROP_NAME is not passed" {
  SERVER_PROPERTIES_PATH=$( fixture_path server.properties )
  [ $( read_server_property | wc -l ) == 26 ]
}

@test "read_server_property does not return any commented lines if no PROP_NAME is passed" {
  SERVER_PROPERTIES_PATH=$( fixture_path server.properties )
  run read_server_property "allow-flight"

  [ -z "$output" ]
}

@test "read_server_property returns the value of the given server property" {
  SERVER_PROPERTIES_PATH=$( fixture_path server.properties )
  run read_server_property "motd"

  [ "$output" = "A Minecraft Server" ]
}

