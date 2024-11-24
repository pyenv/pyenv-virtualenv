#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

stub_pyenv() {
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-hooks "virtualenv : echo"
  stub pyenv-rehash " : echo rehashed"
}

unstub_pyenv() {
  unstub pyenv-version-name
  unstub pyenv-prefix
  unstub pyenv-hooks
  unstub pyenv-rehash
}

@test "create virtualenv by conda create" {
  export PYENV_VERSION="miniconda3-3.16.0"
  setup_conda "${PYENV_VERSION}"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "conda * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  run pyenv-virtualenv venv

  assert_success
  assert_output_wildcards <<OUT
PYENV_VERSION=miniconda3-3.16.0 conda create --name venv --yes --file /dev/fd/*
rehashed
OUT

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_m_venv "miniconda3-3.16.0"
}

@test "create virtualenv by conda create with -p" {
  export PYENV_VERSION="miniconda3-3.16.0"
  setup_conda "${PYENV_VERSION}"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "conda * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  run pyenv-virtualenv -p python3.5 venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=miniconda3-3.16.0 conda create --name venv --yes python=3.5
rehashed
OUT

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_m_venv "miniconda3-3.16.0"
}

@test "create virtualenv by conda create with --python" {
  export PYENV_VERSION="miniconda3-3.16.0"
  setup_conda "${PYENV_VERSION}"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "conda * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  run pyenv-virtualenv --python=python3.5 venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=miniconda3-3.16.0 conda create --name venv --yes python=3.5
rehashed
OUT

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_m_venv "miniconda3-3.16.0"
}
