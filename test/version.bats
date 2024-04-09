#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "display virtualenv version" {
  setup_virtualenv "2.7.7"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/2.7.7'"
  stub pyenv-version-name "echo 2.7.7"
  stub pyenv-exec "python -m venv --help : false"
  stub pyenv-exec "virtualenv --version : echo \"1.11\""

  run pyenv-virtualenv --version

  assert_success
  [[ "$output" == "pyenv-virtualenv "?.?.?" (virtualenv 1.11)" ]]

  unstub pyenv-prefix
  unstub pyenv-exec
  teardown_virtualenv "2.7.7"
}

@test "display venv version" {
  setup_m_venv "3.4.1"
  stub pyenv-version-name "echo 3.4.1"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/3.4.1'"
  stub pyenv-exec "python -m venv --help : true"

  run pyenv-virtualenv --version

  assert_success
  [[ "$output" == "pyenv-virtualenv "?.?.?" (python -m venv)" ]]

  unstub pyenv-prefix
  teardown_m_venv "3.4.1"
}
