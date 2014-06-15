#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

stub_pyenv() {
  export PYENV_VERSION="$1"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-hooks "virtualenv : echo"
  stub pyenv-rehash " : echo rehashed"
}

unstub_pyenv() {
  unset PYENV_VERSION
  unstub pyenv-version-name
  unstub pyenv-prefix
  unstub pyenv-hooks
  unstub pyenv-rehash
}

@test "use pyvenv if virtualenv is not available" {
  stub_pyenv "3.4.1"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "bin=\"${PYENV_ROOT}/versions/venv/bin\";mkdir -p \"\$bin\";touch \"\$bin/pip3.4\";echo PYENV_VERSION=\${PYENV_VERSION} ensurepip"
  stub pyenv-exec "echo 3.4"

  remove_executable "3.4.1" "virtualenv"
  create_executable "3.4.1" "pyvenv"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.4.1 pyvenv ${PYENV_ROOT}/versions/venv
PYENV_VERSION=venv ensurepip
rehashed
OUT
  assert [ -e "${PYENV_ROOT}/versions/venv/bin/pip" ]

  unstub_pyenv
  unstub pyenv-exec
}

@test "not use pyvenv if virtualenv is available" {
  stub_pyenv "3.4.1"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo 3.4"

  create_executable "3.4.1" "virtualenv"
  create_executable "3.4.1" "pyvenv"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.4.1 virtualenv ${PYENV_ROOT}/versions/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
}

@test "install virtualenv if pyvenv is not avaialble" {
  stub_pyenv "3.2.1"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo 3.2"

  remove_executable "3.2.1" "virtualenv"
  remove_executable "3.2.1" "pyvenv"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.2.1 pip install virtualenv
PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
}

@test "install virtualenv if -p has given" {
  stub_pyenv "3.4.1"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo 3.4"

  remove_executable "3.4.1" "virtualenv"
  create_executable "3.4.1" "pyvenv"

  run pyenv-virtualenv -p python3 venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.4.1 pip install virtualenv
PYENV_VERSION=3.4.1 virtualenv --python=python3 ${PYENV_ROOT}/versions/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
}

@test "install virtualenv if --python has given" {
  stub_pyenv "3.4.1"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo 3.4"

  remove_executable "3.4.1" "virtualenv"
  create_executable "3.4.1" "pyvenv"

  run pyenv-virtualenv --python=python3 venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.4.1 pip install virtualenv
PYENV_VERSION=3.4.1 virtualenv --python=python3 ${PYENV_ROOT}/versions/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
}

@test "install virtualenv with unsetting troublesome pip options" {
  stub_pyenv "3.2.1"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-exec "echo PIP_REQUIRE_VENV=\${PIP_REQUIRE_VENV} PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo PIP_REQUIRE_VENV=\${PIP_REQUIRE_VENV} PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo 3.2"

  remove_executable "3.2.1" "virtualenv"
  remove_executable "3.2.1" "pyvenv"

  PIP_REQUIRE_VENV="true" run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PIP_REQUIRE_VENV= PYENV_VERSION=3.2.1 pip install virtualenv
PIP_REQUIRE_VENV= PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/venv
rehashed
OUT

  unstub_pyenv
  unstub pyenv-exec
}

@test "install pip without using ensurepip" {
  stub_pyenv "3.3.5"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-which "pip : echo no pip; false"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} no ensurepip; false"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} no setuptools; false"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} setuptools"
  stub pyenv-exec "bin=\"${PYENV_ROOT}/versions/venv/bin\";mkdir -p \"\$bin\";touch \"\$bin/pip\";echo PYENV_VERSION=\${PYENV_VERSION} pip"
  stub pyenv-exec "echo 3.3"
  stub curl "echo ez_setup.py"
  stub curl "echo get_pip.py"

  remove_executable "3.3.5" "virtualenv"
  create_executable "3.3.5" "pyvenv"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.3.5 pyvenv ${PYENV_ROOT}/versions/venv
PYENV_VERSION=venv no ensurepip
PYENV_VERSION=venv setuptools
PYENV_VERSION=venv pip
rehashed
OUT
  assert [ -e "${PYENV_ROOT}/versions/venv/bin/pip" ]

  unstub_pyenv
  unstub pyenv-which
  unstub pyenv-exec
}
