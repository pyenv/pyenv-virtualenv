#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  unset PYENV_VERSION
  unset PYENV_ACTIVATE_SHELL
  unset VIRTUAL_ENV
  unset CONDA_DEFAULT_ENV
  unset PYTHONHOME
  unset _OLD_VIRTUAL_PYTHONHOME
  unset PYENV_VIRTUALENV_DISABLE_PROMPT
  unset PYENV_VIRTUAL_ENV_DISABLE_PROMPT
  unset VIRTUAL_ENV_DISABLE_PROMPT
  unset _OLD_VIRTUAL_PS1
}

@test "deactivate virtualenv" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (verbose)" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate --verbose

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (quiet)" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (with shell activation)" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
unset PYENV_VERSION;
unset PYENV_ACTIVATE_SHELL;
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (with shell activation) (quiet)" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="bash" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
unset PYENV_VERSION;
unset PYENV_ACTIVATE_SHELL;
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv which has been activated manually" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (fish)" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
set -e VIRTUAL_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  setenv PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  setenv PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
if functions -g deactivate;
  functions -e deactivate;
end;
EOS
}

@test "deactivate virtualenv (fish) (quiet)" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="fish" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
set -e VIRTUAL_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  setenv PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  setenv PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
if functions -g deactivate;
  functions -e deactivate;
end;
EOS
}

@test "deactivate virtualenv (fish) (with shell activation)" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
set -e PYENV_VERSION;
set -e PYENV_ACTIVATE_SHELL;
set -e VIRTUAL_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  setenv PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  setenv PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
if functions -g deactivate;
  functions -e deactivate;
end;
EOS
}

@test "deactivate virtualenv (fish) (with shell activation) (quiet)" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=1

  PYENV_SHELL="fish" run pyenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
set -e PYENV_VERSION;
set -e PYENV_ACTIVATE_SHELL;
set -e VIRTUAL_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  setenv PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  setenv PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
if functions -g deactivate;
  functions -e deactivate;
end;
EOS
}

@test "deactivate virtualenv which has been activated manually (fish)" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
pyenv-virtualenv: deactivate venv
set -e VIRTUAL_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  setenv PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  setenv PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
if functions -g deactivate;
  functions -e deactivate;
end;
EOS
}

@test "should fail if deactivate is invoked as a command" {
  run pyenv-deactivate

  assert_failure
}
