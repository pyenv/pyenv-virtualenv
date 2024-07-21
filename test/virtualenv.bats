#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

stub_pyenv() {
  setup_version "${PYENV_VERSION}"
  create_executable "${PYENV_VERSION}" "virtualenv"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-hooks "virtualenv : echo"
  stub pyenv-rehash " : echo rehashed"
}

unstub_pyenv() {
  unstub pyenv-prefix
  unstub pyenv-hooks
  unstub pyenv-rehash
  teardown_version "${PYENV_VERSION}"
}

@test "create virtualenv from given version" {
  export PYENV_VERSION="2.7.11"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : false"
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\"; mkdir -p \"\$2/bin\""
  stub pyenv-exec "python -s -m ensurepip : false"
  stub pyenv-exec "python -s */get-pip.py : true"
  stub curl true
  create_executable "${PYENV_VERSION}" "python-config"
  create_executable "${PYENV_VERSION}" "python2-config"
  create_executable "${PYENV_VERSION}" "python2.7-config"

  run pyenv-virtualenv "2.7.11" "venv"

  assert_output <<OUT
PYENV_VERSION=2.7.11 virtualenv ${PYENV_ROOT}/versions/2.7.11/envs/venv
Installing pip from https://bootstrap.pypa.io/pip/2.7/get-pip.py...
rehashed
OUT
  assert_success
  for x in pydoc python-config python2-config python2.7-config; do
    assert [ -x "${PYENV_ROOT}/versions/2.7.11/envs/venv/bin/$x" ]
  done

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  unstub curl
}

@test "create virtualenv from a given prefix" {
  stub_pyenv "2.7.11"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : false"
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : false"
  stub pyenv-exec "python -s */get-pip.py : true"
  stub curl true
  stub pyenv-latest "-f 2.7 : echo 2.7.11"

  run pyenv-virtualenv "2.7" "venv"

  assert_output <<OUT
PYENV_VERSION=2.7.11 virtualenv ${PYENV_ROOT}/versions/2.7.11/envs/venv
Installing pip from https://bootstrap.pypa.io/pip/2.7/get-pip.py...
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/2.7.11/envs/venv/bin/pydoc" ]
  assert [ ! -e "${PYENV_ROOT}/versions/2.7" ]
  assert_success

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  unstub curl
}

@test "create virtualenv from current version" {
  export PYENV_VERSION="2.7.11"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : false"
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : false"
  stub pyenv-exec "python -s */get-pip.py : true"
  stub curl true

  run pyenv-virtualenv venv

  assert_output <<OUT
PYENV_VERSION=2.7.11 virtualenv ${PYENV_ROOT}/versions/2.7.11/envs/venv
Installing pip from https://bootstrap.pypa.io/pip/2.7/get-pip.py...
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/2.7.11/envs/venv/bin/pydoc" ]
  assert_success

  unstub_pyenv
  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  unstub curl
}

@test "create virtualenv with short options" {
  export PYENV_VERSION="2.7.11"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : false"
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : false"
  stub pyenv-exec "python -s */get-pip.py : true"
  stub curl true

  run pyenv-virtualenv -v -p ${TMP}/python venv

  assert_output <<OUT
PYENV_VERSION=2.7.11 virtualenv --verbose --python=${TMP}/python ${PYENV_ROOT}/versions/2.7.11/envs/venv
Installing pip from https://bootstrap.pypa.io/pip/2.7/get-pip.py...
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/2.7.11/envs/venv/bin/pydoc" ]
  assert_success

  unstub_pyenv
  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  unstub curl
}

@test "create virtualenv with long options" {
  export PYENV_VERSION="2.7.11"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-version-name "echo \${PYENV_VERSION}"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : false"
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : false"
  stub pyenv-exec "python -s */get-pip.py : true"
  stub curl true

  run pyenv-virtualenv --verbose --python=${TMP}/python venv

  assert_output <<OUT
PYENV_VERSION=2.7.11 virtualenv --verbose --python=${TMP}/python ${PYENV_ROOT}/versions/2.7.11/envs/venv
Installing pip from https://bootstrap.pypa.io/pip/2.7/get-pip.py...
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/2.7.11/envs/venv/bin/pydoc" ]
  assert_success

  unstub_pyenv
  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  unstub curl
}

@test "no whitespace allowed in virtualenv name" {
  run pyenv-virtualenv "2.7.11" "foo bar"

  assert_failure
  assert_output <<OUT
pyenv-virtualenv: no whitespace allowed in virtualenv name.
OUT
}

@test "no tab allowed in virtualenv name" {
  run pyenv-virtualenv "2.7.11" "foo	bar baz"

  assert_failure
  assert_output <<OUT
pyenv-virtualenv: no whitespace allowed in virtualenv name.
OUT
}

@test "system not allowed as virtualenv name" {
  run pyenv-virtualenv "2.7.11" "system"

  assert_failure
  assert_output <<OUT
pyenv-virtualenv: \`system' is not allowed as virtualenv name.
OUT
}

@test "no slash allowed in virtualenv name" {
  run pyenv-virtualenv "2.7.11" "foo/bar"

  assert_failure
  assert_output <<OUT
pyenv-virtualenv: no slash allowed in virtualenv name.
OUT
}

@test "slash allowed if it is the long name of the virtualenv" {
  export PYENV_VERSION="2.7.11"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : false"
  stub pyenv-exec "virtualenv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-exec "python -s -m ensurepip : false"
  stub pyenv-exec "python -s */get-pip.py : true"
  stub curl true

  run pyenv-virtualenv "2.7.11" "2.7.11/envs/foo"

  assert_output <<OUT
PYENV_VERSION=2.7.11 virtualenv ${PYENV_ROOT}/versions/2.7.11/envs/foo
Installing pip from https://bootstrap.pypa.io/pip/2.7/get-pip.py...
rehashed
OUT
  assert [ -x "${PYENV_ROOT}/versions/2.7.11/envs/foo/bin/pydoc" ]
  assert_success

  unstub_pyenv
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  unstub curl
}
