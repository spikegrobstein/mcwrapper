#! /usr/bin/env bats

load test_helper

setup() {
  set_path
  set_tmp
  set_faux_server

  cp $( fixture_path backup/* ) "$TMP/"

  mkdir backups
  mkdir world
  echo "data" > world/data1
  echo "data" > world/data2
}

teardown() {
  rm_tmp
}

@test "backup should not error" {
  mcwrapper backup
  sleep 1
  mcwrapper backup
  sleep 1
  mcwrapper backup
}

@test "backup should create a new archive" {
  mcwrapper backup

  ls backups | {
    run wc -l
    [ $output -eq 2 ]
  }
}

@test "backup should create a symlink to the latest backup" {
  [ ! -e backups/latest ]

  mcwrapper backup

  [ -L backups/latest ]
}

@test "backup should clean up backups when it hits the BACKUPS_TO_KEEP threshold" {
  mcwrapper backup
  sleep 1
  mcwrapper backup
  sleep 1
  mcwrapper backup
  sleep 1
  mcwrapper backup
  sleep 1
  mcwrapper backup
  sleep 1
  mcwrapper backup
  sleep 1
  mcwrapper backup
  sleep 1
  mcwrapper backup
  sleep 1

  ls backups | {
    run wc -l

    # BACKUPS_TO_KEEP + 1 (symlink)
    [ $output -eq 6 ]
  }
}
