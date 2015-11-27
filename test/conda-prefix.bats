#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "display conda root" {
  setup_conda "anaconda-2.3.0"
  stub pyenv-version-name "echo anaconda-2.3.0"
  stub pyenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""

  PYENV_VERSION="anaconda-2.3.0" run pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${PYENV_ROOT}/versions/anaconda-2.3.0
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  teardown_conda "anaconda-2.3.0"
}

@test "display conda env" {
  setup_conda "anaconda-2.3.0" "foo"
  stub pyenv-version-name "echo anaconda-2.3.0/envs/foo"
  stub pyenv-prefix "anaconda-2.3.0/envs/foo : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""

  PYENV_VERSION="anaconda-2.3.0/envs/foo" run pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  teardown_conda "anaconda-2.3.0" "foo"
}
