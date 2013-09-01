#! /usr/bin/env bats

# test the genconfig action

setup() {
  export TMP="$BATS_TEST_DIRNAME/tmp"
  export PATH="$BATS_TEST_DIRNAME/../libexec:${PATH}"
  export MINECRAFT_SERVER_PATH="$TMP/faux_minecraft_server.jar"

  mkdir -p "$TMP"

  cp "$BATS_TEST_DIRNAME/fixtures/faux_minecraft_server/faux_minecraft_server.jar" "$TMP/"

  pushd "$TMP" &> /dev/null
}

teardown() {
  rm -rf "$TMP"
}

@test "genconfig exits abnormally if config already exists" {
  touch mcwrapper.conf

  run mcwrapper genconfig

  [ $status -ne 0 ]
}

@test "genconfig creates the config if it does not exist" {
  [ ! -e "mcwrapper.conf" ]

  mcwrapper genconfig

  [ -e "mcwrapper.conf" ]
}

