#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "deactivate virtualenv" {
  export PYENV_VIRTUALENV_INIT=1

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if declare -f deactivate 1>/dev/null 2>&1; then
  export PYENV_DEACTIVATE="\$VIRTUAL_ENV";
  deactivate;
else
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
fi;
EOS
}

@test "deactivate virtualenv (quiet)" {
  export PYENV_VIRTUALENV_INIT=1

  PYENV_SHELL="bash" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
if declare -f deactivate 1>/dev/null 2>&1; then
  export PYENV_DEACTIVATE="\$VIRTUAL_ENV";
  deactivate;
else
  false;
fi;
EOS
}

@test "deactivate virtualenv (w/o pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if declare -f deactivate 1>/dev/null 2>&1; then
  pyenv shell --unset;
  export PYENV_DEACTIVATE="\$VIRTUAL_ENV";
  deactivate;
else
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
fi;
EOS
}

@test "deactivate virtualenv (w/o pyenv-virtualenv-init) (quiet)" {
  export PYENV_VIRTUALENV_INIT=

  PYENV_SHELL="bash" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
if declare -f deactivate 1>/dev/null 2>&1; then
  pyenv shell --unset;
  export PYENV_DEACTIVATE="\$VIRTUAL_ENV";
  deactivate;
else
  false;
fi;
EOS
}

@test "deactivate virtualenv (fish)" {
  export PYENV_VIRTUALENV_INIT=1

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if functions -q deactivate
  setenv PYENV_DEACTIVATE "\$VIRTUAL_ENV";
  deactivate;
else;
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
end;
EOS
}

@test "deactivate virtualenv (fish) (quiet)" {
  export PYENV_VIRTUALENV_INIT=1

  PYENV_SHELL="fish" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
if functions -q deactivate
  setenv PYENV_DEACTIVATE "\$VIRTUAL_ENV";
  deactivate;
else;
  false;
end;
EOS
}

@test "deactivate virtualenv (fish) (w/o pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
if functions -q deactivate
  pyenv shell --unset;
  setenv PYENV_DEACTIVATE "\$VIRTUAL_ENV";
  deactivate;
else;
  echo "pyenv-virtualenv: no virtualenv has been activated." 1>&2;
  false;
end;
EOS
}

@test "deactivate virtualenv (fish) (w/o pyenv-virtualenv-init) (quiet)" {
  export PYENV_VIRTUALENV_INIT=

  PYENV_SHELL="fish" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
if functions -q deactivate
  pyenv shell --unset;
  setenv PYENV_DEACTIVATE "\$VIRTUAL_ENV";
  deactivate;
else;
  false;
end;
EOS
}
@test "should fail if deactivate is invoked as a command" {
  run pyenv-deactivate

  assert_failure
}
