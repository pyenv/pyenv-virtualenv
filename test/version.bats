#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  export PYENV_VIRTUALENV_VERSION="20140602"
}

@test "display virtualenv version" {
  stub pyenv-which "virtualenv : true"
  stub pyenv-which "pyvenv : true"
  stub pyenv-exec "virtualenv --version : echo \"1.11\""

  run pyenv-virtualenv --version

  unstub pyenv-which
  unstub pyenv-exec

  assert_success
  assert_output "pyenv-virtualenv ${PYENV_VIRTUALENV_VERSION} (virtualenv 1.11)"
}

@test "display pyvenv version" {
  stub pyenv-which "virtualenv : false"
  stub pyenv-which "pyvenv : echo \"${PYENV_ROOT}/versions/3.3.3/bin/pyvenv\""
  stub pyenv-which "pyvenv : echo \"${PYENV_ROOT}/versions/3.3.3/bin/pyvenv\""
  stub pyenv-root "echo \"${PYENV_ROOT}\""

  run pyenv-virtualenv --version

  unstub pyenv-which
  unstub pyenv-root

  assert_success
  assert_output "pyenv-virtualenv ${PYENV_VIRTUALENV_VERSION} (pyvenv 3.3.3)"
}
