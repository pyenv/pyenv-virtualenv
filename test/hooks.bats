#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
  export HOOK_PATH="${TMP}/i has hooks"
  mkdir -p "$HOOK_PATH"
}

@test "pyenv-virtualenv hooks" {
  cat > "${HOOK_PATH}/virtualenv.bash" <<OUT
before_virtualenv 'echo before: \$VIRTUALENV_PATH'
after_virtualenv 'echo after: \$STATUS'
OUT
  setup_version "3.2.1"
  create_executable "3.2.1" "virtualenv"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/3.2.1'"
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/3.2.1'"
  stub pyenv-hooks "virtualenv : echo '$HOOK_PATH'/virtualenv.bash"
  stub pyenv-exec "echo PYENV_VERSION=3.2.1 \"\$@\""
  stub pyenv-exec "echo PYENV_VERSION=3.2.1 \"\$@\""
  stub pyenv-rehash "echo rehashed"

  run pyenv-virtualenv "3.2.1" venv

  assert_success
  assert_output <<-OUT
before: ${PYENV_ROOT}/versions/3.2.1/envs/venv
PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/3.2.1/envs/venv
PYENV_VERSION=3.2.1 python -s -m ensurepip
after: 0
rehashed
OUT

  unstub pyenv-prefix
  unstub pyenv-hooks
  unstub pyenv-exec
  unstub pyenv-rehash
  teardown_version "3.2.1"
}
