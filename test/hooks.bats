#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  export HOOK_PATH="${TMP}/i has hooks"
  mkdir -p "$HOOK_PATH"
  unset PYENV_VIRTUALENV_PROMPT
}

@test "pyenv-virtualenv hooks" {
  cat > "${HOOK_PATH}/virtualenv.bash" <<OUT
before_virtualenv 'echo before: \$VIRTUALENV_PATH'
after_virtualenv 'echo after: \$STATUS'
OUT
  setup_version "3.5.1"
  create_executable "3.5.1" "virtualenv"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/3.5.1'"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/3.5.1'"
  stub pyenv-exec "python -m venv --help : true"
  stub pyenv-hooks "virtualenv : echo '$HOOK_PATH'/virtualenv.bash"
  stub pyenv-exec "echo PYENV_VERSION=3.5.1 \"\$@\""
  stub pyenv-exec "echo PYENV_VERSION=3.5.1 \"\$@\""
  stub pyenv-rehash "echo rehashed"

  run pyenv-virtualenv "3.5.1" venv

  assert_success
  assert_output <<-OUT
before: ${PYENV_ROOT}/versions/3.5.1/envs/venv
PYENV_VERSION=3.5.1 virtualenv ${PYENV_ROOT}/versions/3.5.1/envs/venv
PYENV_VERSION=3.5.1 python -s -m ensurepip
after: 0
rehashed
OUT

  unstub pyenv-prefix
  unstub pyenv-hooks
  unstub pyenv-exec
  unstub pyenv-rehash
  teardown_version "3.5.1"
}

@test "pyenv-sh-activate hooks" {
  cat > "${HOOK_PATH}/activate.bash" <<OUT
before_activate 'echo "before"'
after_activate 'echo "after"'
OUT
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix ""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-hooks "activate : echo '$HOOK_PATH'/activate.bash"
  stub pyenv-sh-deactivate ""

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate

  assert_success
  assert_output <<EOS
before
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(venv) \${PS1:-}";
after
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-hooks
  unstub pyenv-sh-deactivate
}

@test "deactivate virtualenv" {
  cat > "${HOOK_PATH}/deactivate.bash" <<OUT
before_deactivate 'echo "before"'
after_deactivate 'echo "after"'
OUT
  export PYENV_VIRTUALENV_INIT=1
  export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=
  stub pyenv-hooks "deactivate : echo '$HOOK_PATH'/deactivate.bash"

  PYENV_SHELL="bash" run pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
before
unset PYENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
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
after
EOS

  unstub pyenv-hooks
}
