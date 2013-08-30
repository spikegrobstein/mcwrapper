
function init_mcwrapper {
  . "$BATS_TEST_DIRNAME/../libexec/mcwrapper"
}

function fixture_path {
  local PATH=$1;shift

  echo "$BATS_TEST_DIRNAME/fixtures/$PATH"
}

