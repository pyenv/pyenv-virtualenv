#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "deactivate virtualenv" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
unset PYENV_ACTIVATE;
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (verbose)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate --verbose

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
unset PYENV_ACTIVATE;
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (no-error)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate --no-error

  assert_success
  assert_output <<EOS
export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
unset PYENV_ACTIVATE;
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (with shell activation)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv shell --unset;
unset PYENV_ACTIVATE_SHELL;
export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
unset PYENV_ACTIVATE;
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (with shell activation) (no-error)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="bash" run pyenv-sh-deactivate --no-error

  assert_success
  assert_output <<EOS
pyenv shell --unset;
unset PYENV_ACTIVATE_SHELL;
export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
unset PYENV_ACTIVATE;
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv which has been activated manually" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE=
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
export PYENV_DEACTIVATE="$VIRTUAL_ENV";
unset PYENV_ACTIVATE;
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (fish)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
setenv PYENV_DEACTIVATE "$PYENV_ACTIVATE";
set -e PYENV_ACTIVATE;
set -e VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (fish) (no-error)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="fish" run pyenv-sh-deactivate --no-error

  assert_success
  assert_output <<EOS
setenv PYENV_DEACTIVATE "$PYENV_ACTIVATE";
set -e PYENV_ACTIVATE;
set -e VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (fish) (with shell activation)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv shell --unset;
set -e PYENV_ACTIVATE_SHELL;
setenv PYENV_DEACTIVATE "$PYENV_ACTIVATE";
set -e PYENV_ACTIVATE;
set -e VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (fish) (with shell activation) (no-error)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="fish" run pyenv-sh-deactivate --no-error

  assert_success
  assert_output <<EOS
pyenv shell --unset;
set -e PYENV_ACTIVATE_SHELL;
setenv PYENV_DEACTIVATE "$PYENV_ACTIVATE";
set -e PYENV_ACTIVATE;
set -e VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv which has been activated manually (fish)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE=
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
setenv PYENV_DEACTIVATE "$VIRTUAL_ENV";
set -e PYENV_ACTIVATE;
set -e VIRTUAL_ENV;
EOS
}

@test "should fail if deactivate is invoked as a command" {
  run pyenv-deactivate

  assert_failure
}
