set_path() {
  export PATH="$BATS_TEST_DIRNAME/../libexec:${PATH}"
}

set_faux_server() {
  SERVERNAME=${1-faux_minecraft_server.jar}
  export MINECRAFT_SERVER_PATH="$TMP/$SERVERNAME"
  cp "$BATS_TEST_DIRNAME/fixtures/faux_minecraft_server/faux_minecraft_server.jar" "$MINECRAFT_SERVER_PATH"
}

set_tmp() {
  export TMP="$BATS_TMPDIR/tmp"

  mkdir -p "$TMP"

  pushd "$TMP" &> /dev/null
}

rm_tmp() {
  rm -rf "$TMP"
}

function init_mcwrapper {
  . "$BATS_TEST_DIRNAME/../libexec/mcwrapper"
}

function fixture_path {
  local PATH=$1;shift

  echo "$BATS_TEST_DIRNAME/fixtures/$PATH"
}

