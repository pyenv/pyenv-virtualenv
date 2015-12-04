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

@test "install pip with ensurepip" {
  export PYENV_VERSION="3.4.1"
  setup_pyvenv "3.4.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "pyvenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";mkdir -p \${PYENV_ROOT}/versions/3.4.1/envs/venv/bin"
  stub pyenv-exec "python -s -m ensurepip : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";touch \${PYENV_ROOT}/versions/3.4.1/envs/venv/bin/pip"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.4.1 pyvenv ${PYENV_ROOT}/versions/3.4.1/envs/venv
PYENV_VERSION=3.4.1/envs/venv python -s -m ensurepip
rehashed
OUT
  assert [ -e "${PYENV_ROOT}/versions/3.4.1/envs/venv/bin/pip" ]

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_pyvenv "3.4.1"
}

@test "install pip without using ensurepip" {
  export PYENV_VERSION="3.3.5"
  setup_pyvenv "3.3.5"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "pyvenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";mkdir -p \${PYENV_ROOT}/versions/3.3.5/envs/venv/bin"
  stub pyenv-exec "python -s -m ensurepip : false"
  stub pyenv-exec "python -s */get-pip.py : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";touch \${PYENV_ROOT}/versions/3.3.5/envs/venv/bin/pip"
  stub curl true

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.3.5 pyvenv ${PYENV_ROOT}/versions/3.3.5/envs/venv
Installing pip from https://bootstrap.pypa.io/get-pip.py...
PYENV_VERSION=3.3.5/envs/venv python -s ${TMP}/pyenv/cache/get-pip.py
rehashed
OUT
  assert [ -e "${PYENV_ROOT}/versions/3.3.5/envs/venv/bin/pip" ]

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_pyvenv "3.3.5"
}
