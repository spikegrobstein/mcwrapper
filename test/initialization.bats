#! /usr/bin/env bats

load test_helper

@test "should set MCWRAPPER_DIR" {
  [ -z "$MCWRAPPER_DIR" ]
  init_mcwrapper
  [ ! -z "$MCWRAPPER_DIR" ]
}

@test "should set MCWRAPPER_CONFIG_NAME" {
  [ -z "$MCWRAPPER_CONFIG_NAME" ]
  init_mcwrapper
  [ ! -z "$MCWRAPPER_CONFIG_NAME" ]
  [ "mcwrapper.conf" = "$MCWRAPPER_CONFIG_NAME" ]
}

@test "should allow override of MCWRAPPER_CONFIG_NAME" {
  MCWRAPPER_CONFIG_NAME='something.conf'
  init_mcwrapper
  [ "something.conf" = "$MCWRAPPER_CONFIG_NAME" ]
}

