#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "deactivate virtualenv" {
  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
declare -f deactivate 1>/dev/null 2>&1 && deactivate
pyenv shell --unset
EOS
}

@test "deactivate virtualenv (fish)" {
  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
functions -q deactivate; and deactivate
pyenv shell --unset
EOS
}
