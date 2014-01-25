#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "activate virtualenv from current version" {
  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
pyenv shell "venv"
source "${PYENV_ROOT}/versions/venv/bin/activate"
EOS
}

@test "activate virtualenv from current version (fish)" {
  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""

  PYENV_SHELL="fish" PYENV_VERSION="venv" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
pyenv shell "venv"
. "${PYENV_ROOT}/versions/venv/bin/activate.fish"
EOS
}

@test "activate virtualenv from command-line argument" {
  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""

  run pyenv-sh-activate "venv27"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
pyenv shell "venv27"
source "${PYENV_ROOT}/versions/venv27/bin/activate"
EOS
}

@test "unset invokes deactivate" {
  run pyenv-sh-activate --unset

  assert_success
  assert_output <<EOS
pyenv deactivate
EOS
}

@test "should fail if the version is not a virtualenv" {
  stub pyenv-virtualenv-prefix "3.3.3 : false"

  run pyenv-sh-activate "3.3.3"

  unstub pyenv-virtualenv-prefix

  assert_failure
}

@test "should fail if there are multiple versions" {
  run pyenv-sh-activate "venv" "venv27"

  assert_failure
  assert_output <<EOS
pyenv-virtualenv: cannot activate multiple versions at once: venv venv27
EOS
}

@test "should fail if activate is invoked as a command" {
  run pyenv-activate

  assert_failure
}
