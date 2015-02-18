#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"

  mkdir -p "$PYENV_VIRTUALENV_TEST_DIR"
  cd "$PYENV_VIRTUALENV_TEST_DIR"
}

create_virtualenv() {
  mkdir -p "${PYENV_ROOT}/versions/$1/bin"
  touch "${PYENV_ROOT}/versions/$1/bin/activate"
}

@test "invocation without 2 arguments prints usage" {
  stub pyenv-help "echo \"Usage: pyenv virtualenv-file-write <file> <venv-name>\""
  run pyenv-virtualenv-file-write
  unstub pyenv-help
  assert_failure "Usage: pyenv virtualenv-file-write <file> <venv-name>"

  run pyenv-virtualenv-file-write "one" ""
  assert_failure
}

@test "setting nonexistent virtualenv fails" {
  assert [ ! -e ".python-venv" ]

  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  run pyenv-virtualenv-file-write ".python-venv" "venv"
  unstub pyenv-prefix

  assert_failure "pyenv-virtualenv: version \`venv' is not a virtualenv"
  assert [ ! -e ".python-venv" ]
}

@test "writes value to arbitrary file" {
  create_virtualenv "venv"

  assert [ ! -e "my-venv" ]

  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  run pyenv-virtualenv-file-write "${PWD}/my-venv" "venv"
  unstub pyenv-prefix

  assert_success ""
  assert [ "$(cat my-venv)" = "venv" ]
}
