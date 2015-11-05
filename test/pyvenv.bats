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

@test "use pyvenv if virtualenv is not available" {
  export PYENV_VERSION="3.4.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "pyvenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  remove_executable "3.4.1" "virtualenv"
  create_executable "3.4.1" "pyvenv"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.4.1 pyvenv ${PYENV_ROOT}/versions/3.4.1/envs/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
}

@test "not use pyvenv if virtualenv is available" {
  export PYENV_VERSION="3.4.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  create_executable "3.4.1" "virtualenv"
  create_executable "3.4.1" "pyvenv"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.4.1 virtualenv ${PYENV_ROOT}/versions/3.4.1/envs/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
}

@test "install virtualenv if pyvenv is not avaialble" {
  export PYENV_VERSION="3.2.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "pip install virtualenv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : false"
  stub pyenv-exec "python -s */get-pip.py : true"
  stub curl true

  remove_executable "3.2.1" "virtualenv"
  remove_executable "3.2.1" "pyvenv"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.2.1 pip install virtualenv
PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/3.2.1/envs/venv
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
  unstub curl
}

@test "install virtualenv if -p has given" {
  export PYENV_VERSION="3.4.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "pip install virtualenv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  remove_executable "3.4.1" "virtualenv"
  create_executable "3.4.1" "pyvenv"

  run pyenv-virtualenv -p ${TMP}/python3 venv

  assert_output <<OUT
PYENV_VERSION=3.4.1 pip install virtualenv
PYENV_VERSION=3.4.1 virtualenv --python=${TMP}/python3 ${PYENV_ROOT}/versions/3.4.1/envs/venv
rehashed
OUT
  assert_success

  unstub_pyenv
  unstub pyenv-exec
}

@test "install virtualenv if --python has given" {
  export PYENV_VERSION="3.4.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "pip install virtualenv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  remove_executable "3.4.1" "virtualenv"
  create_executable "3.4.1" "pyvenv"

  run pyenv-virtualenv --python=${TMP}/python3 venv

  assert_output <<OUT
PYENV_VERSION=3.4.1 pip install virtualenv
PYENV_VERSION=3.4.1 virtualenv --python=${TMP}/python3 ${PYENV_ROOT}/versions/3.4.1/envs/venv
rehashed
OUT
  assert_success

  unstub_pyenv
  unstub pyenv-exec
}

@test "install virtualenv with unsetting troublesome pip options" {
  export PYENV_VERSION="3.2.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "pip install virtualenv : echo PIP_REQUIRE_VENV=\${PIP_REQUIRE_VENV} PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "virtualenv * : echo PIP_REQUIRE_VENV=\${PIP_REQUIRE_VENV} PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : false"
  stub pyenv-exec "python -s */get-pip.py : true"
  stub curl true

  remove_executable "3.2.1" "virtualenv"
  remove_executable "3.2.1" "pyvenv"

  PIP_REQUIRE_VENV="true" run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PIP_REQUIRE_VENV= PYENV_VERSION=3.2.1 pip install virtualenv
PIP_REQUIRE_VENV= PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/3.2.1/envs/venv
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
  unstub curl
}
