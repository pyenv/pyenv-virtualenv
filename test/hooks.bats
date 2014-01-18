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
  stub pyenv-prefix "echo '${PYENV_ROOT}/versions/\${PYENV_VERSION}'"
  stub pyenv-which "virtualenv : echo '${PYENV_ROOT}/versions/bin/virtualenv'" \
                   "pyvenv : false"
  stub pyenv-hooks "virtualenv : echo '$HOOK_PATH'/virtualenv.bash"
  stub pyenv-exec "echo PYENV_VERSION=\${PYENV_VERSION} \"\$@\""
  stub pyenv-rehash "echo rehashed"

  mkdir -p "${PYENV_ROOT}/versions/3.2.1"
  run pyenv-virtualenv "3.2.1" venv

  assert_success
  assert_output <<-OUT
before: ${PYENV_ROOT}/versions/venv
PYENV_VERSION=3.2.1 virtualenv ${PYENV_ROOT}/versions/venv
after: 0
rehashed
OUT
}
