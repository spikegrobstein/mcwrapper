#! /usr/bin/env bats

# test the genconfig action

load test_helper

setup() {
  set_tmp
  set_path
  set_faux_server
}

teardown() {
  rm_tmp
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

