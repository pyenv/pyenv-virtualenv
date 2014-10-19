#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

stub_pyenv() {
  create_executable "${PYENV_VERSION}" "virtualenv"
  remove_executable "${PYENV_VERSION}" "pyvenv"

  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-hooks "virtualenv : echo"
  stub pyenv-rehash " : echo rehashed"
}

unstub_pyenv() {
  unstub pyenv-prefix
  unstub pyenv-hooks
  unstub pyenv-rehash
}

@test "create virtualenv from given version" {
  export PYENV_VERSION="3.2.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-exec "virtualenv ${PYENV_ROOT}/versions/venv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -m ensurepip : false"
  stub pyenv-exec "python */ez_setup.py : true"
  stub pyenv-exec "python */get-pip.py : true"
  stub curl true
  stub curl true

  run pyenv-virtualenv "3.2.1" "venv"

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/venv
Installing setuptools from https://bootstrap.pypa.io/ez_setup.py...
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
  unstub curl
}

@test "create virtualenv from current version" {
  export PYENV_VERSION="3.2.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-exec "virtualenv ${PYENV_ROOT}/versions/venv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -m ensurepip : false"
  stub pyenv-exec "python */ez_setup.py : true"
  stub pyenv-exec "python */get-pip.py : true"
  stub curl true
  stub curl true

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/venv
Installing setuptools from https://bootstrap.pypa.io/ez_setup.py...
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT

  unstub_pyenv
  unstub pyenv-version-name
  unstub pyenv-exec
  unstub curl
}

@test "create virtualenv with short options" {
  export PYENV_VERSION="3.2.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-exec "virtualenv --verbose --python=python ${PYENV_ROOT}/versions/venv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -m ensurepip : false"
  stub pyenv-exec "python */ez_setup.py : true"
  stub pyenv-exec "python */get-pip.py : true"
  stub curl true
  stub curl true

  run pyenv-virtualenv -v -p python venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.2.1 virtualenv --verbose --python=python ${PYENV_ROOT}/versions/venv
Installing setuptools from https://bootstrap.pypa.io/ez_setup.py...
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT

  unstub_pyenv
  unstub pyenv-version-name
  unstub pyenv-exec
  unstub curl
}

@test "create virtualenv with long options" {
  export PYENV_VERSION="3.2.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-exec "virtualenv --verbose --python=python ${PYENV_ROOT}/versions/venv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -m ensurepip : false"
  stub pyenv-exec "python */ez_setup.py : true"
  stub pyenv-exec "python */get-pip.py : true"
  stub curl true
  stub curl true

  run pyenv-virtualenv --verbose --python=python venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.2.1 virtualenv --verbose --python=python ${PYENV_ROOT}/versions/venv
Installing setuptools from https://bootstrap.pypa.io/ez_setup.py...
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT

  unstub_pyenv
  unstub pyenv-version-name
  unstub pyenv-exec
  unstub curl
}

@test "no whitespace allowed in virtualenv name" {
  run pyenv-virtualenv "3.2.1" "foo bar"

  assert_failure
  assert_output <<OUT
pyenv-virtualenv: no whitespace allowed in virtualenv name.
OUT
}

@test "no tab allowed in virtualenv name" {
  run pyenv-virtualenv "3.2.1" "foo	bar baz"

  assert_failure
  assert_output <<OUT
pyenv-virtualenv: no whitespace allowed in virtualenv name.
OUT
}
