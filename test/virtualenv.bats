#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

stub_pyenv() {
  export PYENV_VERSION="$1"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/\${PYENV_VERSION}'"
  stub pyenv-which "virtualenv : echo '${PYENV_ROOT}/versions/bin/virtualenv'"
  stub pyenv-which "pyvenv : false"
  stub pyenv-hooks "virtualenv : echo"
  stub pyenv-rehash " : echo rehashed"
}

unstub_pyenv() {
  unset PYENV_VERSION
  unstub pyenv-prefix
  unstub pyenv-which
  unstub pyenv-hooks
  unstub pyenv-rehash
}

@test "create virtualenv from given version" {
  stub_pyenv "3.2.1"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo 3.2"

  run pyenv-virtualenv "3.2.1" "venv"

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
}

@test "create virtualenv from current version" {
  stub_pyenv "3.2.1"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo 3.2"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-version-name
  unstub pyenv-exec
}

@test "create virtualenv with short options" {
  stub_pyenv "3.2.1"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo 3.2"

  run pyenv-virtualenv -v -p python venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.2.1 virtualenv --verbose --python=python ${PYENV_ROOT}/versions/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-version-name
  unstub pyenv-exec
}

@test "create virtualenv with long options" {
  stub_pyenv "3.2.1"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo 3.2"

  run pyenv-virtualenv --verbose --python=python venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.2.1 virtualenv --verbose --python=python ${PYENV_ROOT}/versions/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-version-name
  unstub pyenv-exec
}
