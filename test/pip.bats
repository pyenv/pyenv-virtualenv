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
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "pyvenv ${PYENV_ROOT}/versions/venv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";mkdir -p \${PYENV_ROOT}/versions/venv/bin"
  stub pyenv-exec "python -m ensurepip : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";touch \${PYENV_ROOT}/versions/venv/bin/pip3.4"
  stub pyenv-exec "python -c * : echo ${PYENV_VERSION%.*}"

  remove_executable "3.4.1" "virtualenv"
  create_executable "3.4.1" "pyvenv"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.4.1 pyvenv ${PYENV_ROOT}/versions/venv
PYENV_VERSION=venv python -m ensurepip
rehashed
OUT
  assert [ -e "${PYENV_ROOT}/versions/venv/bin/pip" ]

  unstub_pyenv
  unstub pyenv-exec
}

@test "install pip without using ensurepip" {
  export PYENV_VERSION="3.3.5"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "pyvenv ${PYENV_ROOT}/versions/venv : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";mkdir -p \${PYENV_ROOT}/versions/venv/bin"
  stub pyenv-exec "python -m ensurepip : false"
  stub pyenv-exec "python */ez_setup.py : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";touch \${PYENV_ROOT}/versions/venv/bin/easy_install"
  stub pyenv-exec "python */get-pip.py : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";touch \${PYENV_ROOT}/versions/venv/bin/pip3.3"
  stub pyenv-exec "python -c * : echo ${PYENV_VERSION%.*}"
  stub curl true
  stub curl true

  remove_executable "3.3.5" "virtualenv"
  create_executable "3.3.5" "pyvenv"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.3.5 pyvenv ${PYENV_ROOT}/versions/venv
Installing setuptools from https://bootstrap.pypa.io/ez_setup.py...
PYENV_VERSION=venv python ${TMP}/pyenv/cache/ez_setup.py
Installing pip from https://bootstrap.pypa.io/get-pip.py...
PYENV_VERSION=venv python ${TMP}/pyenv/cache/get-pip.py
rehashed
OUT
  assert [ -e "${PYENV_ROOT}/versions/venv/bin/pip" ]

  unstub_pyenv
  unstub pyenv-exec
}
