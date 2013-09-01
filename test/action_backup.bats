#! /usr/bin/env bats

# test uncompressed backups

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

@test "backup creates a new archive in backups directory" {
  mcwrapper backup

  ls backups | {
    run wc -l
    [ $status -eq 0 ]
    [ $output -eq 2 ]
  }
}

@test "backup copies server.properties" {
  mcwrapper backup

  ls backups/latest/server.properties | {
    run wc -l
    [ $status -eq 0 ]
    [ $output -gt 0 ]
  }
}

@test "backup copies .txt files" {
  mcwrapper backup

  ls backups/latest/*.txt | {
    run wc -l
    [ $status -eq 0 ]
    [ $output -gt 0 ]
  }
}

@test "backup creates a symlink to the latest backup" {
  [ ! -e backups/latest ]

  mcwrapper backup

  [ -L backups/latest ]
}

@test "backup cleans up backups when it hits the BACKUPS_TO_KEEP threshold" {
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

@test "backup creates backups directory" {
  rm -rf backups

  [ ! -d "backups" ]

  mcwrapper backup

  [ -d "backups" ]
}

