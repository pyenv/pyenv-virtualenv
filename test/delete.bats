#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "delete virtualenv" {
  mkdir -p "${PYENV_ROOT}/versions/venv27"

  stub pyenv-virtualenv-prefix "venv27 : true"
  stub pyenv-hooks "virtualenv-delete : true"
  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "venv27"

  assert_success

  unstub pyenv-virtualenv-prefix
  unstub pyenv-hooks
  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/venv27" ]
}

@test "delete virtualenv by symlink" {
  mkdir -p "${PYENV_ROOT}/versions/2.7.11/envs/venv27"
  ln -fs "${PYENV_ROOT}/versions/2.7.11/envs/venv27" "${PYENV_ROOT}/versions/venv27"

  stub pyenv-hooks "virtualenv-delete : true"
  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "venv27"

  assert_success

  unstub pyenv-hooks
  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ ! -L "${PYENV_ROOT}/versions/venv27" ]
}

@test "delete virtualenv with symlink" {
  mkdir -p "${PYENV_ROOT}/versions/2.7.11/envs/venv27"
  ln -fs "${PYENV_ROOT}/versions/2.7.11/envs/venv27" "${PYENV_ROOT}/versions/venv27"

  stub pyenv-hooks "virtualenv-delete : true"
  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "2.7.11/envs/venv27"

  assert_success

  unstub pyenv-hooks
  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ ! -L "${PYENV_ROOT}/versions/venv27" ]
}

@test "not delete virtualenv with different symlink" {
  mkdir -p "${PYENV_ROOT}/versions/2.7.8/envs/venv27"
  mkdir -p "${PYENV_ROOT}/versions/2.7.11/envs/venv27"
  ln -fs "${PYENV_ROOT}/versions/2.7.8/envs/venv27" "${PYENV_ROOT}/versions/venv27"

  stub pyenv-hooks "virtualenv-delete : true"
  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "2.7.11/envs/venv27"

  assert_success

  unstub pyenv-hooks
  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ -L "${PYENV_ROOT}/versions/venv27" ]
}

@test "not delete virtualenv with same name" {
  mkdir -p "${PYENV_ROOT}/versions/2.7.11/envs/venv27"
  mkdir -p "${PYENV_ROOT}/versions/venv27"

  stub pyenv-hooks "virtualenv-delete : true"
  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "2.7.11/envs/venv27"

  assert_success

  unstub pyenv-hooks
  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ -d "${PYENV_ROOT}/versions/venv27" ]
}

@test "delete virtualenv runs hooks" {
  export HOOK_PATH="${TMP}/i has hooks"
  mkdir -p "$HOOK_PATH"
  cat > "${HOOK_PATH}/virtualenv-delete.bash" <<OUT
before_virtualenv_delete 'echo "before: \$VIRTUALENV_NAME \$VIRTUALENV_PATH exists=\$([ -d "\$VIRTUALENV_PATH" ] && echo yes || echo no)"'
after_virtualenv_delete 'echo "after: \$VIRTUALENV_NAME \$VIRTUALENV_PATH exists=\$([ -d "\$VIRTUALENV_PATH" ] && echo yes || echo no)"'
OUT
  mkdir -p "${PYENV_ROOT}/versions/venv27"

  stub pyenv-virtualenv-prefix "venv27 : true"
  stub pyenv-hooks "virtualenv-delete : echo '$HOOK_PATH'/virtualenv-delete.bash"
  stub pyenv-rehash "true"

  run pyenv-virtualenv-delete -f "venv27"

  assert_success
  assert_output <<OUT
before: venv27 ${PYENV_ROOT}/versions/venv27 exists=yes
after: venv27 ${PYENV_ROOT}/versions/venv27 exists=no
OUT

  unstub pyenv-virtualenv-prefix
  unstub pyenv-hooks
  unstub pyenv-rehash

  [ ! -d "${PYENV_ROOT}/versions/venv27" ]
}

@test "delete virtualenv does not run hooks when declined" {
  export HOOK_PATH="${TMP}/i has hooks"
  mkdir -p "$HOOK_PATH"
  cat > "${HOOK_PATH}/virtualenv-delete.bash" <<OUT
before_virtualenv_delete 'echo before'
after_virtualenv_delete 'echo after'
OUT
  mkdir -p "${PYENV_ROOT}/versions/venv27"

  stub pyenv-virtualenv-prefix "venv27 : true"
  stub pyenv-hooks "virtualenv-delete : echo '$HOOK_PATH'/virtualenv-delete.bash"

  run pyenv-virtualenv-delete "venv27" <<<"n"

  assert_failure
  [[ "$output" != *before* ]]
  [[ "$output" != *after* ]]

  unstub pyenv-virtualenv-prefix
  unstub pyenv-hooks

  [ -d "${PYENV_ROOT}/versions/venv27" ]
}
