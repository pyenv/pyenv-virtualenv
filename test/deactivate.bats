#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "deactivate virtualenv" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
export PYENV_DEACTIVATE="${PYENV_ROOT}/versions/venv";
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (verbose)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate --verbose

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
export PYENV_DEACTIVATE="${PYENV_ROOT}/versions/venv";
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (quiet)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
export PYENV_DEACTIVATE="${PYENV_ROOT}/versions/venv";
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (with shell activation)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
unset PYENV_VERSION;
unset PYENV_ACTIVATE_SHELL;
export PYENV_DEACTIVATE="${PYENV_ROOT}/versions/venv";
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (with shell activation) (quiet)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="bash" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
unset PYENV_VERSION;
unset PYENV_ACTIVATE_SHELL;
export PYENV_DEACTIVATE="${PYENV_ROOT}/versions/venv";
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv which has been activated manually" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
export PYENV_DEACTIVATE="${PYENV_ROOT}/versions/venv";
unset VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (fish)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
setenv PYENV_DEACTIVATE "${PYENV_ROOT}/versions/venv";
set -e VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (fish) (quiet)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="fish" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
setenv PYENV_DEACTIVATE "${PYENV_ROOT}/versions/venv";
set -e VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (fish) (with shell activation)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
set -e PYENV_VERSION;
set -e PYENV_ACTIVATE_SHELL;
setenv PYENV_DEACTIVATE "${PYENV_ROOT}/versions/venv";
set -e VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv (fish) (with shell activation) (quiet)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="fish" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
set -e PYENV_VERSION;
set -e PYENV_ACTIVATE_SHELL;
setenv PYENV_DEACTIVATE "${PYENV_ROOT}/versions/venv";
set -e VIRTUAL_ENV;
EOS
}

@test "deactivate virtualenv which has been activated manually (fish)" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
setenv PYENV_DEACTIVATE "${PYENV_ROOT}/versions/venv";
set -e VIRTUAL_ENV;
EOS
}

@test "should fail if deactivate is invoked as a command" {
  run pyenv-deactivate

  assert_failure
}
