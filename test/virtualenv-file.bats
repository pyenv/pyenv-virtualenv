#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_VIRTUALENV_TEST_DIR"
  cd "$PYENV_VIRTUALENV_TEST_DIR"
}

create_file() {
  mkdir -p "$(dirname "$1")"
  touch "$1"
}

@test "in current directory" {
  create_file ".python-venv"
  run pyenv-virtualenv-file
  assert_success "${PYENV_VIRTUALENV_TEST_DIR}/.python-venv"
}

@test "alternate file in current directory" {
  create_file ".pyenv-venv"
  run pyenv-virtualenv-file
  assert_success "${PYENV_VIRTUALENV_TEST_DIR}/.pyenv-venv"
}

@test ".python-venv has precedence over alternate file" {
  create_file ".python-venv"
  create_file ".pyenv-venv"
  run pyenv-virtualenv-file
  assert_success "${PYENV_VIRTUALENV_TEST_DIR}/.python-venv"
}

@test "in parent directory" {
  create_file ".python-venv"
  mkdir -p project
  cd project
  run pyenv-virtualenv-file
  assert_success "${PYENV_VIRTUALENV_TEST_DIR}/.python-venv"
}

@test "topmost file has precedence" {
  create_file ".python-venv"
  create_file "project/.python-venv"
  cd project
  run pyenv-virtualenv-file
  assert_success "${PYENV_VIRTUALENV_TEST_DIR}/project/.python-venv"
}

@test "alternate file has precedence if higher" {
  create_file ".python-venv"
  create_file "project/.pyenv-venv"
  cd project
  run pyenv-virtualenv-file
  assert_success "${PYENV_VIRTUALENV_TEST_DIR}/project/.pyenv-venv"
}

@test "PYENV_DIR has precedence over PWD" {
  create_file "widget/.python-venv"
  create_file "project/.python-venv"
  cd project
  PYENV_DIR="${PYENV_VIRTUALENV_TEST_DIR}/widget" run pyenv-virtualenv-file
  assert_success "${PYENV_VIRTUALENV_TEST_DIR}/widget/.python-venv"
}

@test "PWD is searched if PYENV_DIR yields no results" {
  mkdir -p "widget/blank"
  create_file "project/.python-venv"
  cd project
  PYENV_DIR="${PYENV_VIRTUALENV_TEST_DIR}/widget/blank" run pyenv-virtualenv-file
  assert_success "${PYENV_VIRTUALENV_TEST_DIR}/project/.python-venv"
}
