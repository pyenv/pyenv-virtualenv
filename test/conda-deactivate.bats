#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  unset PYENV_VERSION
  unset PYENV_ACTIVATE_SHELL
  unset PYENV_DEACTIVATE
  unset VIRTUAL_ENV
  unset CONDA_DEFAULT_ENV
  unset PYTHONHOME
  unset _OLD_VIRTUAL_PYTHONHOME
  unset PYENV_VIRTUALENV_DISABLE_PROMPT
  unset PYENV_VIRTUAL_ENV_DISABLE_PROMPT
  unset VIRTUAL_ENV_DISABLE_PROMPT
  unset _OLD_VIRTUAL_PS1
}

@test "deactivate conda root" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export PYENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="root"

  create_conda "anaconda-2.3.0"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate anaconda-2.3.0
export PYENV_DEACTIVATE="${PYENV_ROOT}/versions/anaconda-2.3.0";
unset VIRTUAL_ENV;
unset CONDA_DEFAULT_ENV;
EOS
}

@test "deactivate conda root (fish)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export PYENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="root"


  create_conda "anaconda-2.3.0"

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate anaconda-2.3.0
setenv PYENV_DEACTIVATE "${PYENV_ROOT}/versions/anaconda-2.3.0";
set -e VIRTUAL_ENV;
set -e CONDA_DEFAULT_ENV;
EOS
}

@test "deactivate conda env" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo"
  export PYENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="foo"


  create_conda "anaconda-2.3.0" "foo"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate anaconda-2.3.0/envs/foo
export PYENV_DEACTIVATE="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo";
unset VIRTUAL_ENV;
unset CONDA_DEFAULT_ENV;
EOS
}
