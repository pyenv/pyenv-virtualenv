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

@test "use venv if virtualenv is not available" {
  export PYENV_VERSION="3.5.1"
  setup_m_venv "3.5.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : true"
  stub pyenv-exec "python -m venv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  run pyenv-virtualenv venv

  assert_output <<OUT
PYENV_VERSION=3.5.1 python -m venv ${PYENV_ROOT}/versions/3.5.1/envs/venv
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/3.5.1/envs/venv/bin/pydoc" ]
  assert_success

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_m_venv "3.5.1"
}

@test "not use venv if virtualenv is available" {
  export PYENV_VERSION="3.5.1"
  setup_m_venv "3.5.1"
  create_executable "3.5.1" "virtualenv"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : true"
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  run pyenv-virtualenv venv

  assert_output <<OUT
PYENV_VERSION=3.5.1 virtualenv ${PYENV_ROOT}/versions/3.5.1/envs/venv
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/3.5.1/envs/venv/bin/pydoc" ]
  assert_success

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_m_venv "3.5.1"
}

@test "install virtualenv if venv is not available" {
  export PYENV_VERSION="3.2.1"
  setup_version "3.2.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : false"
  stub pyenv-exec "pip install virtualenv* : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""

  run pyenv-virtualenv venv

  assert_output <<OUT
PYENV_VERSION=3.2.1 pip install virtualenv==13.1.2
PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/3.2.1/envs/venv
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/3.2.1/envs/venv/bin/pydoc" ]
  assert_success

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_version "3.2.1"
}

@test "install virtualenv if -p has given" {
  export PYENV_VERSION="3.5.1"
  setup_m_venv "3.5.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : true"
  stub pyenv-exec "pip install virtualenv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  run pyenv-virtualenv -p ${TMP}/python3 venv

  assert_output <<OUT
PYENV_VERSION=3.5.1 pip install virtualenv
PYENV_VERSION=3.5.1 virtualenv --python=${TMP}/python3 ${PYENV_ROOT}/versions/3.5.1/envs/venv
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/3.5.1/envs/venv/bin/pydoc" ]
  assert_success

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_m_venv "3.5.1"
}

@test "install virtualenv if --python has given" {
  export PYENV_VERSION="3.5.1"
  setup_m_venv "3.5.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : true"
  stub pyenv-exec "pip install virtualenv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"

  run pyenv-virtualenv --python=${TMP}/python3 venv

  assert_output <<OUT
PYENV_VERSION=3.5.1 pip install virtualenv
PYENV_VERSION=3.5.1 virtualenv --python=${TMP}/python3 ${PYENV_ROOT}/versions/3.5.1/envs/venv
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/3.5.1/envs/venv/bin/pydoc" ]
  assert_success

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_m_venv "3.5.1"
}

@test "install virtualenv with unsetting troublesome pip options" {
  export PYENV_VERSION="3.2.1"
  setup_version "3.2.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : false"
  stub pyenv-exec "pip install virtualenv* : echo PIP_REQUIRE_VENV=\${PIP_REQUIRE_VENV} PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "virtualenv * : echo PIP_REQUIRE_VENV=\${PIP_REQUIRE_VENV} PYENV_VERSION=\${PYENV_VERSION} \"\$@\""

  PIP_REQUIRE_VENV="true" run pyenv-virtualenv venv

  assert_output <<OUT
PIP_REQUIRE_VENV= PYENV_VERSION=3.2.1 pip install virtualenv==13.1.2
PIP_REQUIRE_VENV= PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/3.2.1/envs/venv
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/3.2.1/envs/venv/bin/pydoc" ]
  assert_success

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_version "3.2.1"
}
