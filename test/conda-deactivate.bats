#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "deactivate conda root" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export PYENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="root"

  create_conda "anaconda-2.3.0"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
unset PYENV_ACTIVATE;
unset VIRTUAL_ENV;
unset CONDA_DEFAULT_ENV;
EOS
}

@test "deactivate conda root (fish)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export PYENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="root"


  create_conda "anaconda-2.3.0"

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
setenv PYENV_DEACTIVATE "${TMP}/pyenv/versions/anaconda-2.3.0";
set -e PYENV_ACTIVATE;
set -e VIRTUAL_ENV;
set -e CONDA_DEFAULT_ENV;
EOS
}

@test "deactivate conda env" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo"
  export PYENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="foo"


  create_conda "anaconda-2.3.0" "foo"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
unset PYENV_ACTIVATE;
unset VIRTUAL_ENV;
unset CONDA_DEFAULT_ENV;
EOS
}
