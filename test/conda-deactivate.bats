#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  unset PYENV_VERSION
  unset PYENV_ACTIVATE_SHELL
  unset PYENV_VIRTUAL_ENV
  unset VIRTUAL_ENV
  unset CONDA_DEFAULT_ENV
  unset PYTHONHOME
  unset _OLD_VIRTUAL_PYTHONHOME
  unset PYENV_VIRTUALENV_VERBOSE_ACTIVATE
  unset PYENV_VIRTUALENV_DISABLE_PROMPT
  unset PYENV_VIRTUAL_ENV_DISABLE_PROMPT
  unset VIRTUAL_ENV_DISABLE_PROMPT
  unset _OLD_VIRTUAL_PS1
  stub pyenv-hooks "deactivate : echo"
}

teardown() {
  unstub pyenv-hooks
}

@test "deactivate conda root" {
  export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export PYENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="root"

  setup_conda "anaconda-2.3.0"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
unset CONDA_PREFIX
unset PYENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
unset CONDA_DEFAULT_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH:-}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME:-}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1:-}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS

  teardown_conda "anaconda-2.3.0"
}

@test "deactivate conda root (fish)" {
  export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0"
  export PYENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="root"

  setup_conda "anaconda-2.3.0"

  PYENV_SHELL="fish" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
set -e PYENV_VIRTUAL_ENV;
set -e VIRTUAL_ENV;
set -e CONDA_DEFAULT_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  set -gx PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  set -gx PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
# check if old prompt function exists
if functions -q _pyenv_old_prompt
  # remove old prompt function if exists.
  functions -e fish_prompt
  functions -c _pyenv_old_prompt fish_prompt
  functions -e _pyenv_old_prompt
end
if functions -q deactivate;
  functions -e deactivate;
end;
EOS

  teardown_conda "anaconda-2.3.0"
}

@test "deactivate conda env" {
  export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo"
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo"
  export PYENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="foo"

  setup_conda "anaconda-2.3.0" "foo"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
. "${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo/etc/conda/deactivate.d/deactivate.sh";
unset CONDA_PREFIX
unset PYENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
unset CONDA_DEFAULT_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH:-}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME:-}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1:-}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS

  teardown_conda "anaconda-2.3.0" "foo"
}
