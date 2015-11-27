#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  export PYENV_VERSION="2.7.8"
  setup_version "2.7.8"
  create_executable "2.7.8" "virtualenv"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-hooks "virtualenv : echo"
  stub pyenv-rehash " : true"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub curl true
}

teardown() {
  unstub curl
  unstub pyenv-version-name
  unstub pyenv-prefix
  unstub pyenv-hooks
  unstub pyenv-rehash
  teardown_version "2.7.8"
  rm -fr "$TMP"/*
}

@test "resolve python executable from enabled version" {
  remove_executable "2.7.7" "python2.7"
  create_executable "2.7.8" "python2.7"
  remove_executable "2.7.9" "python2.7"

  stub pyenv-exec "virtualenv --verbose * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"
  stub pyenv-which "python2.7 : echo ${PYENV_ROOT}/versions/2.7.8/bin/python2.7"

  run pyenv-virtualenv --verbose --python=python2.7 venv

  assert_output <<OUT
PYENV_VERSION=2.7.8 virtualenv --verbose --python=${PYENV_ROOT}/versions/2.7.8/bin/python2.7 ${PYENV_ROOT}/versions/2.7.8/envs/venv
OUT
  assert_success

  unstub pyenv-which
  unstub pyenv-exec

  remove_executable "2.7.7" "python2.7"
  remove_executable "2.7.8" "python2.7"
  remove_executable "2.7.9" "python2.7"
}

@test "resolve python executable from other versions" {
  remove_executable "2.7.7" "python2.7"
  remove_executable "2.7.8" "python2.7"
  create_executable "2.7.9" "python2.7"

  stub pyenv-exec "virtualenv --verbose * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : true"
  stub pyenv-which "python2.7 : false"
  stub pyenv-whence "python2.7 : echo 2.7.7; echo 2.7.8; echo 2.7.9"
  stub pyenv-which "python2.7 : echo ${PYENV_ROOT}/versions/2.7.9/bin/python2.7"

  run pyenv-virtualenv --verbose --python=python2.7 venv

  assert_output <<OUT
PYENV_VERSION=2.7.8 virtualenv --verbose --python=${PYENV_ROOT}/versions/2.7.9/bin/python2.7 ${PYENV_ROOT}/versions/2.7.8/envs/venv
OUT
  assert_success

  unstub pyenv-which
  unstub pyenv-whence
  unstub pyenv-exec

  remove_executable "2.7.7" "python2.7"
  remove_executable "2.7.8" "python2.7"
  remove_executable "2.7.9" "python2.7"
}

@test "cannot resolve python executable" {
  remove_executable "2.7.7" "python2.7"
  remove_executable "2.7.8" "python2.7"
  remove_executable "2.7.9" "python2.7"

  stub pyenv-which "python2.7 : false"
  stub pyenv-whence "python2.7 : false"
  stub pyenv-which "python2.7 : false"

  run pyenv-virtualenv --verbose --python=python2.7 venv

  assert_output <<OUT
pyenv-virtualenv: \`python2.7' is not installed in pyenv.
OUT
  assert_failure

  unstub pyenv-which
  unstub pyenv-whence

  remove_executable "2.7.7" "python2.7"
  remove_executable "2.7.8" "python2.7"
  remove_executable "2.7.9" "python2.7"
}
