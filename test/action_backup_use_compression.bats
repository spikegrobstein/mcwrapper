#! /usr/bin/env bats

# test backup function with compression

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

@test "backup with tgz compression creates .tgz file" {
  COMPRESS_BACKUP=tgz mcwrapper backup

  ls backups/*.tgz | {
    run wc -l
    [ $output -gt 0 ]
  }
}

@test "backup with zip compression creates .zip file" {
  COMPRESS_BACKUP=zip mcwrapper backup

  ls backups/*.zip | {
    run wc -l
    [ $output -gt 0 ]
  }
}

@test "backup with unsupported compression errors out" {
  run COMPRESS_BACKUP=fakezip mcwrapper backup

  [ $status -ne 0 ]
}
