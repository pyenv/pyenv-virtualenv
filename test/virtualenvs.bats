#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  setup_m_venv "2.7.6/envs/venv27"
  echo "home = ${PYENV_ROOT}/versions/2.7.6/bin" > "${PYENV_ROOT}/versions/2.7.6/envs/venv27/pyvenv.cfg"
  ln -s "${PYENV_ROOT}/versions/2.7.6/envs/venv27" "${PYENV_ROOT}/versions/venv27"

  setup_m_venv "3.3.3/envs/venv33"
  echo "home = ${PYENV_ROOT}/versions/3.3.3/bin" > "${PYENV_ROOT}/versions/3.3.3/envs/venv33/pyvenv.cfg"
  ln -s "${PYENV_ROOT}/versions/3.3.3/envs/venv33" "${PYENV_ROOT}/versions/venv33"
}

@test "list virtual environments" {
  stub pyenv-version-name ": echo system"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27 (created from ${PYENV_ROOT}/versions/2.7.6)
  3.3.3/envs/venv33 (created from ${PYENV_ROOT}/versions/3.3.3)
  venv27 --> ${PYENV_ROOT}/versions/2.7.6/envs/venv27
  venv33 --> ${PYENV_ROOT}/versions/3.3.3/envs/venv33
OUT

  unstub pyenv-version-name
}

@test "list virtual environments with hit prefix" {
  stub pyenv-version-name ": echo 3.3.3/envs/venv33"
  stub pyenv-version-origin ": echo PYENV_VERSION"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27 (created from ${PYENV_ROOT}/versions/2.7.6)
* 3.3.3/envs/venv33 (created from ${PYENV_ROOT}/versions/3.3.3) (set by PYENV_VERSION)
  venv27 --> ${PYENV_ROOT}/versions/2.7.6/envs/venv27
  venv33 --> ${PYENV_ROOT}/versions/3.3.3/envs/venv33
OUT

  unstub pyenv-version-name
  unstub pyenv-version-origin
}

@test "list bare virtual environments" {
  run pyenv-virtualenvs --bare

  assert_success
  assert_output <<OUT
2.7.6/envs/venv27
3.3.3/envs/venv33
venv27
venv33
OUT
}

@test "list bare virtual environments without aliases" {
  run pyenv-virtualenvs --bare --skip-aliases

  assert_success
  assert_output <<OUT
2.7.6/envs/venv27
3.3.3/envs/venv33
OUT
}

@test "list virtual environments without aliases" {
  stub pyenv-version-name ": echo system"

  run pyenv-virtualenvs --skip-aliases

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27 (created from ${PYENV_ROOT}/versions/2.7.6)
  3.3.3/envs/venv33 (created from ${PYENV_ROOT}/versions/3.3.3)
OUT

  unstub pyenv-version-name
}

@test "hit prefix matches alias version name" {
  stub pyenv-version-name ": echo venv27"
  stub pyenv-version-origin ": echo PYENV_VERSION"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27 (created from ${PYENV_ROOT}/versions/2.7.6)
  3.3.3/envs/venv33 (created from ${PYENV_ROOT}/versions/3.3.3)
* venv27 --> ${PYENV_ROOT}/versions/2.7.6/envs/venv27 (set by PYENV_VERSION)
  venv33 --> ${PYENV_ROOT}/versions/3.3.3/envs/venv33
OUT

  unstub pyenv-version-name
  unstub pyenv-version-origin
}

@test "completions output" {
  run pyenv-virtualenvs --complete

  assert_success
  assert_output <<OUT
--bare
--skip-aliases
OUT
}
