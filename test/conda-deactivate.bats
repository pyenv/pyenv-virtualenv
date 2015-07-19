#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "deactivate conda root" {
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export PYENV_ACTIVATE_SHELL=

  create_conda "anaconda-2.3.0"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if [ -f "${PYENV_ROOT}/versions/anaconda-2.3.0/bin/deactivate" ]; then
  export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
  unset PYENV_ACTIVATE;
  . "${PYENV_ROOT}/versions/anaconda-2.3.0/bin/deactivate";
else
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
fi;
EOS
}

@test "deactivate conda root (fish)" {
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export PYENV_ACTIVATE_SHELL=

  create_conda "anaconda-2.3.0"

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_failure
  assert_output <<EOS
pyenv-virtualenv: Only bash and zsh are supported by Anaconda/Miniconda
false
EOS
}

@test "deactivate conda env" {
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo"
  export PYENV_ACTIVATE_SHELL=

  create_conda "anaconda-2.3.0" "foo"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if [ -f "${PYENV_ROOT}/versions/anaconda-2.3.0/bin/deactivate" ]; then
  export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
  unset PYENV_ACTIVATE;
  . "${PYENV_ROOT}/versions/anaconda-2.3.0/bin/deactivate";
else
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
fi;
EOS
}
