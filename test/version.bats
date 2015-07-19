#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  export PYENV_VIRTUALENV_VERSION="20150719"
}

@test "display virtualenv version" {
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/2.7.7'"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/2.7.7'"
  stub pyenv-exec "virtualenv --version : echo \"1.11\""

  create_executable "2.7.7" "virtualenv"
  remove_executable "2.7.7" "pyvenv"

  run pyenv-virtualenv --version

  assert_success
  assert_output "pyenv-virtualenv ${PYENV_VIRTUALENV_VERSION} (virtualenv 1.11)"

  unstub pyenv-prefix
  unstub pyenv-exec
}

@test "display pyvenv version" {
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/3.4.1'"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/3.4.1'"
  stub pyenv-which "pyvenv : echo \"${PYENV_ROOT}/versions/3.4.1/bin/pyvenv\""
  stub pyenv-root "echo \"${PYENV_ROOT}\""

  remove_executable "3.4.1" "virtualenv"
  create_executable "3.4.1" "pyvenv"

  run pyenv-virtualenv --version

  assert_success
  assert_output "pyenv-virtualenv ${PYENV_VIRTUALENV_VERSION} (pyvenv 3.4.1)"

  unstub pyenv-prefix
  unstub pyenv-root
}
