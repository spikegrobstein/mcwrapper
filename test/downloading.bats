#! /usr/bin/env bats

# test utility function

load test_helper

setup() {
  set_path
  set_tmp
  set_faux_server
  init_mcwrapper
}

teardown() {
  rm_tmp
}

@test "get_server_download_uri returns a URL" {
  run get_server_download_uri

  [ $status -eq 0 ]
  [[ $output =~ ^https?: ]]
}

