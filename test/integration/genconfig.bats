#! /usr/bin/env bats

# test the genconfig action

setup() {
  export TMP="$BATS_TEST_DIRNAME/tmp"
  mkdir -p $TMP
}

teardown() {
  rm -f "$TMP"/*
}

run_mcwrapper() {
  run "$BATS_TEST_DIRNAME/../../libexec/mcwrapper" $@
}

@test "genconfig exits abnormally if config already exists" {
  pushd $TMP &> /dev/null
  run touch mcwrapper.conf

  run_mcwrapper genconfig

  [ $status -ne 0 ]
}

@test "genconfig creates the config if it does not exist" {
  pushd $TMP &> /dev/null

  run_mcwrapper genconfig

  [ $status -eq 0 ]
  [ -e "mcwrapper.conf" ]
}

