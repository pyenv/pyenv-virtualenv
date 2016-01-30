#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "delete virtualenv" {
  mkdir -p "${PYENV_ROOT}/versions/venv27"

  stub pyenv-virtualenv-prefix "venv27 : true"
  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "venv27"

  assert_success

  unstub pyenv-virtualenv-prefix
  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/venv27" ]
}

@test "delete virtualenv by symlink" {
  mkdir -p "${PYENV_ROOT}/versions/2.7.11/envs/venv27"
  ln -fs "${PYENV_ROOT}/versions/2.7.11/envs/venv27" "${PYENV_ROOT}/versions/venv27"

  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "venv27"

  assert_success

  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ ! -L "${PYENV_ROOT}/versions/venv27" ]
}

@test "delete virtualenv with symlink" {
  mkdir -p "${PYENV_ROOT}/versions/2.7.11/envs/venv27"
  ln -fs "${PYENV_ROOT}/versions/2.7.11/envs/venv27" "${PYENV_ROOT}/versions/venv27"

  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "2.7.11/envs/venv27"

  assert_success

  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ ! -L "${PYENV_ROOT}/versions/venv27" ]
}

@test "not delete virtualenv with different symlink" {
  mkdir -p "${PYENV_ROOT}/versions/2.7.8/envs/venv27"
  mkdir -p "${PYENV_ROOT}/versions/2.7.11/envs/venv27"
  ln -fs "${PYENV_ROOT}/versions/2.7.8/envs/venv27" "${PYENV_ROOT}/versions/venv27"

  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "2.7.11/envs/venv27"

  assert_success

  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ -L "${PYENV_ROOT}/versions/venv27" ]
}

@test "not delete virtualenv with same name" {
  mkdir -p "${PYENV_ROOT}/versions/2.7.11/envs/venv27"
  mkdir -p "${PYENV_ROOT}/versions/venv27"

  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "2.7.11/envs/venv27"

  assert_success

  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ -d "${PYENV_ROOT}/versions/venv27" ]
}
