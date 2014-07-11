#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "deactivate virtualenv" {
  export PYENV_VIRTUALENV_INIT=1
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if declare -f deactivate 1>/dev/null 2>&1; then
  export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
  unset PYENV_ACTIVATE;
  deactivate;
else
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
fi;
EOS
}

@test "deactivate virtualenv (verbose)" {
  export PYENV_VIRTUALENV_INIT=1
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="bash" run pyenv-sh-deactivate --verbose

  assert_success
  assert_output <<EOS
if declare -f deactivate 1>/dev/null 2>&1; then
  echo "pyenv-virtualenv: deactivate venv" 1>&2;
  export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
  unset PYENV_ACTIVATE;
  deactivate;
else
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
fi;
EOS
}

@test "deactivate virtualenv (no-error)" {
  export PYENV_VIRTUALENV_INIT=1
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="bash" run pyenv-sh-deactivate --no-error

  assert_success
  assert_output <<EOS
if declare -f deactivate 1>/dev/null 2>&1; then
  export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
  unset PYENV_ACTIVATE;
  deactivate;
else
  false;
fi;
EOS
}

@test "deactivate virtualenv (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if declare -f deactivate 1>/dev/null 2>&1; then
  pyenv shell --unset;
  export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
  unset PYENV_ACTIVATE;
  deactivate;
else
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
fi;
EOS
}

@test "deactivate virtualenv (without pyenv-virtualenv-init) (no-error)" {
  export PYENV_VIRTUALENV_INIT=
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="bash" run pyenv-sh-deactivate --no-error

  assert_success
  assert_output <<EOS
if declare -f deactivate 1>/dev/null 2>&1; then
  pyenv shell --unset;
  export PYENV_DEACTIVATE="$PYENV_ACTIVATE";
  unset PYENV_ACTIVATE;
  deactivate;
else
  false;
fi;
EOS
}

@test "deactivate virtualenv which has been activated manually" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if declare -f deactivate 1>/dev/null 2>&1; then
  export PYENV_DEACTIVATE="$VIRTUAL_ENV";
  unset PYENV_ACTIVATE;
  deactivate;
else
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
fi;
EOS
}

@test "deactivate virtualenv (fish)" {
  export PYENV_VIRTUALENV_INIT=1
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if functions -q deactivate;
  setenv PYENV_DEACTIVATE "$PYENV_ACTIVATE";
  set -e PYENV_ACTIVATE;
  deactivate;
else;
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
end;
EOS
}

@test "deactivate virtualenv (fish) (no-error)" {
  export PYENV_VIRTUALENV_INIT=1
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="fish" run pyenv-sh-deactivate --no-error

  assert_success
  assert_output <<EOS
if functions -q deactivate;
  setenv PYENV_DEACTIVATE "$PYENV_ACTIVATE";
  set -e PYENV_ACTIVATE;
  deactivate;
else;
  false;
end;
EOS
}

@test "deactivate virtualenv (fish) (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if functions -q deactivate;
  pyenv shell --unset;
  setenv PYENV_DEACTIVATE "$PYENV_ACTIVATE";
  set -e PYENV_ACTIVATE;
  deactivate;
else;
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
end;
EOS
}

@test "deactivate virtualenv (fish) (without pyenv-virtualenv-init) (no-error)" {
  export PYENV_VIRTUALENV_INIT=
  export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="fish" run pyenv-sh-deactivate --no-error

  assert_success
  assert_output <<EOS
if functions -q deactivate;
  pyenv shell --unset;
  setenv PYENV_DEACTIVATE "$PYENV_ACTIVATE";
  set -e PYENV_ACTIVATE;
  deactivate;
else;
  false;
end;
EOS
}

@test "deactivate virtualenv which has been activated manually (fish)" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if functions -q deactivate;
  setenv PYENV_DEACTIVATE "$VIRTUAL_ENV";
  set -e PYENV_ACTIVATE;
  deactivate;
else;
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
end;
EOS
}

@test "should fail if deactivate is invoked as a command" {
  run pyenv-deactivate

  assert_failure
}
