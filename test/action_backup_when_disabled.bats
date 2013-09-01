#! /usr/bin/env bats

# test uncompressed backups

load test_helper

setup() {
  set_path
  set_tmp
  set_faux_server

  cp $( fixture_path backup_disabled/* ) "$TMP/"

  mkdir backups
  mkdir world
  echo "data" > world/data1
  echo "data" > world/data2
}

teardown() {
  rm_tmp
}

@test "does not backup when BACKUPS_TO_KEEP=0" {
  run mcwrapper backup

  [ $status -ne 0 ]

  ls backups | {
    run wc -l
    [ $output -eq 0 ]
  }
}
