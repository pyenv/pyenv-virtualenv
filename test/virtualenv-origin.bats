#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_VIRTUALENV_TEST_DIR"
  cd "$PYENV_VIRTUALENV_TEST_DIR"
}

@test "detects PYENV_VIRTUALENV" {
  PYENV_VIRTUALENV=1 run pyenv-virtualenv-origin
  assert_success "PYENV_VIRTUALENV environment variable"
}

@test "detects local file" {
  touch .python-venv
  run pyenv-virtualenv-origin
  assert_success "${PWD}/.python-venv"
}

@test "detects alternate file" {
  touch .pyenv-venv
  run pyenv-virtualenv-origin
  assert_success "${PWD}/.pyenv-venv"
}
