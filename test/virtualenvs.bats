#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  mkdir -p "${PYENV_ROOT}/versions/2.7.6/envs/venv27"
  mkdir -p "${PYENV_ROOT}/versions/3.3.3/envs/venv33"
  ln -s "${PYENV_ROOT}/versions/2.7.6/envs/venv27" "${PYENV_ROOT}/versions/venv27"
  ln -s "${PYENV_ROOT}/versions/3.3.3/envs/venv33" "${PYENV_ROOT}/versions/venv33"
}

@test "list virtual environments" {
  stub pyenv-version-name ": echo system"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27
  3.3.3/envs/venv33
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
  2.7.6/envs/venv27
* 3.3.3/envs/venv33 (set by PYENV_VERSION)
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
  2.7.6/envs/venv27
  3.3.3/envs/venv33
OUT

  unstub pyenv-version-name
}

@test "hit prefix matches alias version name" {
  stub pyenv-version-name ": echo venv27"
  stub pyenv-version-origin ": echo PYENV_VERSION"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27
  3.3.3/envs/venv33
* venv27 --> ${PYENV_ROOT}/versions/2.7.6/envs/venv27 (set by PYENV_VERSION)
  venv33 --> ${PYENV_ROOT}/versions/3.3.3/envs/venv33
OUT

  unstub pyenv-version-name
  unstub pyenv-version-origin
}

@test "no warning with --bare and no virtualenvs" {
  rm -rf "${PYENV_ROOT}/versions"
  mkdir -p "${PYENV_ROOT}/versions"

  run pyenv-virtualenvs --bare

  assert_success
  assert_output ""
}

@test "completions output" {
  run pyenv-virtualenvs --complete

  assert_success
  assert_output <<OUT
--bare
--skip-aliases
OUT
}
