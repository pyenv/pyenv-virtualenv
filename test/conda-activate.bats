#!/usr/bin/env bats

load test_helper

setup() {
  export HOME="${TMP}"
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "activate conda root from current version" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "anaconda-2.3.0"
  stub pyenv-version-name "echo anaconda-2.3.0"
  stub pyenv-virtualenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
unset PYENV_DEACTIVATE;
export PYENV_ACTIVATE="${PYENV_ROOT}/versions/anaconda-2.3.0";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0";
export CONDA_DEFAULT_ENV="root";
EOS
}

@test "activate conda root from current version (fish)" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "anaconda-2.3.0"
  stub pyenv-version-name "echo anaconda-2.3.0"
  stub pyenv-virtualenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""

  PYENV_SHELL="fish" PYENV_VERSION="anaconda-2.3.0" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
set -e PYENV_DEACTIVATE;
setenv PYENV_ACTIVATE "${TMP}/pyenv/versions/anaconda-2.3.0";
setenv VIRTUAL_ENV "${TMP}/pyenv/versions/anaconda-2.3.0";
setenv CONDA_DEFAULT_ENV "root";
EOS
}

@test "activate conda root from command-line argument" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "anaconda-2.3.0"
  create_conda "miniconda-3.9.1"
  stub pyenv-virtualenv-prefix "miniconda-3.9.1 : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1\""
  stub pyenv-prefix "miniconda-3.9.1 : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1\""
  stub pyenv-prefix "miniconda-3.9.1 : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1\""

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0" run pyenv-sh-activate "miniconda-3.9.1"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
pyenv shell "miniconda-3.9.1";
export PYENV_ACTIVATE_SHELL=1;
unset PYENV_DEACTIVATE;
export PYENV_ACTIVATE="${PYENV_ROOT}/versions/miniconda-3.9.1";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/miniconda-3.9.1";
export CONDA_DEFAULT_ENV="root";
EOS
}

@test "activate conda env from current version" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "anaconda-2.3.0" "foo"
  stub pyenv-version-name "echo anaconda-2.3.0/envs/foo"
  stub pyenv-virtualenv-prefix "anaconda-2.3.0/envs/foo : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""
  stub pyenv-prefix "anaconda-2.3.0/envs/foo : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""
  stub pyenv-prefix "anaconda-2.3.0/envs/foo : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0/envs/foo" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
unset PYENV_DEACTIVATE;
export PYENV_ACTIVATE="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo";
export CONDA_DEFAULT_ENV="foo";
EOS
}

@test "activate conda env from command-line argument" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "anaconda-2.3.0" "foo"
  create_conda "miniconda-3.9.1" "bar"
  stub pyenv-virtualenv-prefix "miniconda-3.9.1/envs/bar : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1\""
  stub pyenv-prefix "miniconda-3.9.1/envs/bar : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar\""
  stub pyenv-prefix "miniconda-3.9.1/envs/bar : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar\""

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0/envs/foo" run pyenv-sh-activate "miniconda-3.9.1/envs/bar"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
pyenv shell "miniconda-3.9.1/envs/bar";
export PYENV_ACTIVATE_SHELL=1;
unset PYENV_DEACTIVATE;
export PYENV_ACTIVATE="${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar";
export CONDA_DEFAULT_ENV="bar";
EOS
}

@test "activate conda env from command-line argument in short-form" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "miniconda-3.9.1" "bar"
  stub pyenv-prefix "bar : false"
  stub pyenv-version-name " : echo miniconda-3.9.1"
  stub pyenv-virtualenv-prefix "miniconda-3.9.1/envs/bar : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar\""
  stub pyenv-prefix "miniconda-3.9.1/envs/bar : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar\""

  PYENV_SHELL="bash" PYENV_VERSION="miniconda-3.9.1" run pyenv-sh-activate "bar"

  unstub pyenv-prefix
  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix

  assert_success
  assert_output <<EOS
pyenv shell "miniconda-3.9.1/envs/bar";
export PYENV_ACTIVATE_SHELL=1;
unset PYENV_DEACTIVATE;
export PYENV_ACTIVATE="${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar";
export CONDA_DEFAULT_ENV="bar";
EOS
}
