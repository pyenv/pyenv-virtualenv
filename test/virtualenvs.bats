#!/usr/bin/env bats

load test_helper

create_m_venv() {
  setup_m_venv "$1"

  local version="${1%%/envs/*}"  # Get the first part of "2.7.6/envs/venv27"
  local venv="${1##*/}"  # Get the last part of "2.7.6/envs/venv27"

  local version_dir="${PYENV_ROOT}/versions/${version}"
  local env_dir="${version_dir}/envs/${venv}"

  echo "home = ${version_dir}/bin" > "${env_dir}/pyvenv.cfg"
  ln -s "${env_dir}" "${PYENV_ROOT}/versions/${venv}"
}

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  create_m_venv "2.7.6/envs/venv27"
  create_m_venv "3.3.3/envs/venv33"
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
