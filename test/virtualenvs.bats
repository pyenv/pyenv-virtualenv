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
  stub pyenv-versions "--bare : echo \"system\";echo \"2.7.6\";echo \"3.3.3\";echo \"venv27\";echo \"venv33\""
  stub pyenv-virtualenv-prefix "2.7.6 : false"
  stub pyenv-virtualenv-prefix "3.3.3 : false"
  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/2.7.6\""
  stub pyenv-virtualenv-prefix "venv33 : echo \"${PYENV_ROOT}/versions/3.3.3\""

  run pyenv-virtualenvs

  unstub pyenv-version-name
  unstub pyenv-versions
  unstub pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
  venv27 (created from ${PYENV_ROOT}/versions/2.7.6)
  venv33 (created from ${PYENV_ROOT}/versions/3.3.3)
OUT
}

@test "list virtual environments with hit prefix" {
  stub pyenv-version-name ": echo venv33"
  stub pyenv-versions "--bare : echo \"system\";echo \"venv27\";echo \"venv33\""
  stub pyenv-virtualenv-prefix "venv27 : echo \"/usr\""
  stub pyenv-virtualenv-prefix "venv33 : echo \"/usr\""

  run pyenv-virtualenvs

  unstub pyenv-version-name
  unstub pyenv-versions
  unstub pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
  venv27 (created from /usr)
* venv33 (created from /usr)
OUT
}

@test "list virtual environments with --bare" {
  stub pyenv-versions "--bare : echo \"system\";echo \"venv27\";echo \"venv33\""
  stub pyenv-virtualenv-prefix "venv27 : echo \"/usr\""
  stub pyenv-virtualenv-prefix "venv33 : echo \"/usr\""

  run pyenv-virtualenvs --bare

  unstub pyenv-versions
  unstub pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
venv27
venv33
OUT
}
