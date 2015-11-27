#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  export PYENV_VIRTUALENV_VERSION="20151103"
}

@test "display virtualenv version" {
  setup_virtualenv "2.7.7"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/2.7.7'"
  stub pyenv-exec "virtualenv --version : echo \"1.11\""

  run pyenv-virtualenv --version

  assert_success
  assert_output "pyenv-virtualenv ${PYENV_VIRTUALENV_VERSION} (virtualenv 1.11)"

  unstub pyenv-prefix
  unstub pyenv-exec
  teardown_virtualenv "2.7.7"
}

@test "display pyvenv version" {
  setup_pyvenv "3.4.1"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/3.4.1'"
  stub pyenv-which "pyvenv : echo \"${PYENV_ROOT}/versions/3.4.1/bin/pyvenv\""

  run pyenv-virtualenv --version

  assert_success
  assert_output "pyenv-virtualenv ${PYENV_VIRTUALENV_VERSION} (pyvenv 3.4.1)"

  unstub pyenv-prefix
  teardown_pyvenv "3.4.1"
}
