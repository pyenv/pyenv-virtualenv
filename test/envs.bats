#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/envs/pyenv"
}

stub_pyenv() {
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-hooks "virtualenv : echo"
  stub pyenv-rehash " : echo rehashed"
}

unstub_pyenv() {
  unstub pyenv-prefix
  unstub pyenv-hooks
  unstub pyenv-rehash
}

@test "path should be handled properly even if there is 'envs' in PYENV_ROOT" {
  export PYENV_VERSION="3.5.1"
  setup_m_venv "3.5.1"
  stub_pyenv "${PYENV_VERSION}"
  stub pyenv-version-name "echo '${PYENV_VERSION}'"
  stub pyenv-prefix " : echo '${PYENV_ROOT}/versions/${PYENV_VERSION}'"
  stub pyenv-virtualenv-prefix " : false"
  stub pyenv-exec "python -m venv --help : true"
  stub pyenv-exec "python -m venv * : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";mkdir -p \${PYENV_ROOT}/versions/3.5.1/envs/venv/bin"
  stub pyenv-exec "python -s -m ensurepip : echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\";touch \${PYENV_ROOT}/versions/3.5.1/envs/venv/bin/pip"

  run pyenv-virtualenv venv

  assert_success
  assert_output <<OUT
PYENV_VERSION=3.5.1 python -m venv ${PYENV_ROOT}/versions/3.5.1/envs/venv
PYENV_VERSION=3.5.1/envs/venv python -s -m ensurepip
rehashed
OUT
  assert [ -e "${PYENV_ROOT}/versions/3.5.1/envs/venv/bin/pip" ]

  unstub_pyenv
  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-exec
  teardown_m_venv "3.5.1"
}
