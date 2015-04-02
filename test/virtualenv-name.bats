#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"

  mkdir -p "${PYENV_VIRTUALENV_TEST_DIR}/myproject"
  cd "${PYENV_VIRTUALENV_TEST_DIR}/myproject"
}

create_virtualenv() {
  mkdir -p "${PYENV_ROOT}/versions/$1/bin"
  touch "${PYENV_ROOT}/versions/$1/bin/activate"
}

@test "no virtualenv selected" {
  assert [ ! -d "${PYENV_ROOT}/versions" ]
  run pyenv-virtualenv-name
  assert_failure ""
}

@test "PYENV_VIRTUALENV has precedence over local" {
  create_virtualenv "foo"
  create_virtualenv "bar"

  cat > ".python-venv" <<<"foo"
  run pyenv-virtualenv-name
  assert_success "foo"

  PYENV_VIRTUALENV=bar run pyenv-virtualenv-name
  assert_success "bar"
}

@test "should fail if the virtualenv is the system" {
  PYENV_VIRTUALENV=system run pyenv-virtualenv-name
  assert_failure "pyenv-virtualenv: version \`system' is not a virtualenv"
}

@test "missing virtualenv" {
  PYENV_VIRTUALENV=foo run pyenv-virtualenv-name

  assert_failure "pyenv-virtualenv: version \`foo' is not a virtualenv"
}
