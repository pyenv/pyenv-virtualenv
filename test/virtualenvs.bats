#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  mkdir -p "${PYENV_ROOT}/versions/2.7.6"
  mkdir -p "${PYENV_ROOT}/versions/3.3.3"
  mkdir -p "${PYENV_ROOT}/versions/venv27"
  mkdir -p "${PYENV_ROOT}/versions/venv33"
}

@test "list virtual environments only" {
  stub pyenv-version-name ": echo system"
  stub pyenv-virtualenv-prefix "2.7.6 : false"
  stub pyenv-virtualenv-prefix "3.3.3 : false"
  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/2.7.6\""
  stub pyenv-virtualenv-prefix "venv33 : echo \"${PYENV_ROOT}/versions/3.3.3\""

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  venv27 (created from ${PYENV_ROOT}/versions/2.7.6)
  venv33 (created from ${PYENV_ROOT}/versions/3.3.3)
OUT

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
}

@test "list virtual environments with hit prefix" {
  stub pyenv-version-name ": echo venv33"
  stub pyenv-virtualenv-prefix "2.7.6 : false"
  stub pyenv-virtualenv-prefix "3.3.3 : false"
  stub pyenv-virtualenv-prefix "venv27 : echo \"/usr\""
  stub pyenv-virtualenv-prefix "venv33 : echo \"/usr\""

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  venv27 (created from /usr)
* venv33 (created from /usr)
OUT

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
}

@test "list virtual environments with --bare" {
  stub pyenv-virtualenv-prefix "2.7.6 : false"
  stub pyenv-virtualenv-prefix "3.3.3 : false"
  stub pyenv-virtualenv-prefix "venv27 : echo \"/usr\""
  stub pyenv-virtualenv-prefix "venv33 : echo \"/usr\""

  run pyenv-virtualenvs --bare

  assert_success
  assert_output <<OUT
venv27
venv33
OUT

  unstub pyenv-virtualenv-prefix
}
