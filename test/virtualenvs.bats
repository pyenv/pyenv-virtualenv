#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  mkdir -p "${PYENV_ROOT}/versions/2.7.6/envs/venv27"
  mkdir -p "${PYENV_ROOT}/versions/3.3.3/envs/venv33"
  ln -s "venv27" "${PYENV_ROOT}/versions/venv27"
  ln -s "venv33" "${PYENV_ROOT}/versions/venv33"
}

create_alias() {
  mkdir -p "${PYENV_ROOT}/versions"
  ln -s "$2" "${PYENV_ROOT}/versions/$1"
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
  2.7.6/envs/venv27
  3.3.3/envs/venv33
OUT

  # unstub pyenv-version-name
  # unstub pyenv-virtualenv-prefix
}

@test "list virtual environments with hit prefix" {
  stub pyenv-version-name ": echo venv33"
  stub pyenv-virtualenv-prefix "2.7.6 : false"
  stub pyenv-virtualenv-prefix "3.3.3 : false"
  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/2.7.6\""
  stub pyenv-virtualenv-prefix "venv33 : echo \"${PYENV_ROOT}/versions/3.3.3\""

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27
* 3.3.3/envs/venv33
OUT

  # unstub pyenv-version-name
  # unstub pyenv-virtualenv-prefix
}

@test "list virtual environments with --bare" {
  stub pyenv-virtualenv-prefix "2.7.6 : false"
  stub pyenv-virtualenv-prefix "3.3.3 : false"
  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/2.7.6\""
  stub pyenv-virtualenv-prefix "venv33 : echo \"${PYENV_ROOT}/versions/3.3.3\""

  run pyenv-virtualenvs --bare --only-aliases

  assert_success
  assert_output <<OUT
venv27
venv33
OUT

  unstub pyenv-virtualenv-prefix
}
