#! /usr/bin/env bats

# test uncompressed backups

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

@test "are_backups_enabled returns true if BACKUPS_TO_KEEP > 0" {
  BACKUPS_TO_KEEP=1

  run are_backups_enabled
  [ $status -eq 0 ]
}

@test "are_backups_enabled returns false if BACKUPS_TO_KEEP == 0" {
  BACKUPS_TO_KEEP=0

  run are_backups_enabled
  [ $status -ne 0 ]
}

@test "is_doing_restore returns true if DOING_RESTORE is set" {
  DOING_RESTORE=1

  run is_doing_restore
  [ $status -eq 0 ]
}

@test "is_doing_restore returns false if DOING_RESTORE is not set" {
  unset DOING_RESTORE

  run is_doing_restore
  [ $status -ne 0 ]
}

@test "start_restore causes is_doing_restore to return true" {
  run is_doing_restore
  [ $status -ne 0 ]
  start_restore

  run is_doing_restore
  [ $status -eq 0 ]
}

@test "end_restore causes is_doing_restore to return false" {
  start_restore

  run is_doing_restore
  [ $status -eq 0 ]

  end_restore
  run is_doing_restore
  [ $status -ne 0 ]
}

@test "check_file_exists returns success if file exists" {
  touch myfile.dat

  check_file_exists "myfile.dat" "test file" 20
}

@test "check_file_exists prints the FILE_DESC if it's supplied and file doesn't exist" {
  run check_file_exists "myfile.dat" "test file" 20

  [ $status -ne 0 ]
  [[ $output =~ ^"test file" ]]
}

@test "check_file_exists prints the FILE_PATH if FILE_DESC is not supplied" {
  run check_file_exists "myfile.dat"

  [ $status -ne 0 ]
  [[ $output =~ ^myfile\.dat ]]
}

@test "check_file_exists exits with status code 1 if EXIT_CODE not supplied" {
  run check_file_exists "myfile.dat" "test file"

  [ $status -eq 1 ]
}

@test "check_file_exists exits with given status code if supplied" {
  run check_file_exists "myfile.dat" "test file" 20

  [ $status -eq 20 ]
}
