#!/usr/bin/env bats

load test_helper

create_m_system_venv() {
  # Create a mock virtual environment in the same way a venv created from
  # the system Python version looks.
  #
  # The venv is in ${PYENV_ROOT}/versions, is not a symlink, and
  # home is /usr/bin in the pyenv.cfg.
  create_executable "$2" "python"
  create_executable "$2" "activate"

  local version="$1"
  local venv="$2"
  local venv_dir="${PYENV_ROOT}/versions/${venv}"

  echo "home = /usr/bin" > "${venv_dir}/pyvenv.cfg"
}


create_m_venv() {
  # Create a mock virtual environment from an installed (not system) Python version.
  #
  # The venv name is a symlink inside ${PYENV_ROOT}/versions that points to
  # the real venv directory inside the Python version used to created and
  # home points to the bin directory inside the venv dir.
  setup_m_venv "$1/envs/$2"

  local version="$1"
  local venv="$2"
  local venv_dir="${PYENV_ROOT}/versions/${version}/envs/${venv}"

  echo "home = ${PYENV_ROOT}/versions/${version}/bin" > "${venv_dir}/pyvenv.cfg"
  ln -sf "${venv_dir}" "${PYENV_ROOT}/versions/${venv}"
}

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "system venv" {
  stub pyenv-version-name ": echo venv314"
  stub pyenv-version-origin ": echo PYENV_VERSION"

  create_m_venv "3.14.3" "venv314"
  create_m_system_venv "3.9.11" "system_venv"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  3.14.3/envs/venv314 (created from ${PYENV_ROOT}/versions/3.14.3)
  system_venv (created from /usr)
* venv314 --> ${PYENV_ROOT}/versions/3.14.3/envs/venv314 (set by PYENV_VERSION)
OUT

  unstub pyenv-version-name
  unstub pyenv-version-origin
}

@test "list virtual environments" {
  stub pyenv-version-name ": echo system"
  stub pyenv-virtualenv-prefix "2.7.6/envs/venv27 : echo \"${PYENV_ROOT}/versions/2.7.6\""
  stub pyenv-virtualenv-prefix "3.3.3/envs/venv33 : echo \"${PYENV_ROOT}/versions/3.3.3\""

  create_m_venv "2.7.6" "venv27"
  create_m_venv "3.3.3" "venv33"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27 (created from ${PYENV_ROOT}/versions/2.7.6)
  3.3.3/envs/venv33 (created from ${PYENV_ROOT}/versions/3.3.3)
  venv27 --> ${PYENV_ROOT}/versions/2.7.6/envs/venv27
  venv33 --> ${PYENV_ROOT}/versions/3.3.3/envs/venv33
OUT

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
}

@test "list virtual environments with hit prefix" {
  stub pyenv-version-name ": echo 3.3.3/envs/venv33"
  stub pyenv-version-origin ": echo PYENV_VERSION"

  create_m_venv "2.7.6" "venv27"
  create_m_venv "3.3.3" "venv33"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27 (created from ${PYENV_ROOT}/versions/2.7.6)
* 3.3.3/envs/venv33 (created from ${PYENV_ROOT}/versions/3.3.3) (set by PYENV_VERSION)
  venv27 --> ${PYENV_ROOT}/versions/2.7.6/envs/venv27
  venv33 --> ${PYENV_ROOT}/versions/3.3.3/envs/venv33
OUT

  unstub pyenv-version-name
  unstub pyenv-version-origin
}

@test "list bare virtual environments" {
  create_m_venv "2.7.6" "venv27"
  create_m_venv "3.3.3" "venv33"

  run pyenv-virtualenvs --bare

  assert_success
  assert_output <<OUT
2.7.6/envs/venv27
3.3.3/envs/venv33
venv27
venv33
OUT
}

@test "list bare virtual environments without aliases" {
  create_m_venv "2.7.6" "venv27"
  create_m_venv "3.3.3" "venv33"

  run pyenv-virtualenvs --bare --skip-aliases

  assert_success
  assert_output <<OUT
2.7.6/envs/venv27
3.3.3/envs/venv33
OUT
}

@test "list virtual environments without aliases" {
  stub pyenv-version-name ": echo system"

  create_m_venv "2.7.6" "venv27"
  create_m_venv "3.3.3" "venv33"

  run pyenv-virtualenvs --skip-aliases

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27 (created from ${PYENV_ROOT}/versions/2.7.6)
  3.3.3/envs/venv33 (created from ${PYENV_ROOT}/versions/3.3.3)
OUT

  unstub pyenv-version-name
}

@test "hit prefix matches alias version name" {
  stub pyenv-version-name ": echo venv27"
  stub pyenv-version-origin ": echo PYENV_VERSION"

  create_m_venv "2.7.6" "venv27"
  create_m_venv "3.3.3" "venv33"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  2.7.6/envs/venv27 (created from ${PYENV_ROOT}/versions/2.7.6)
  3.3.3/envs/venv33 (created from ${PYENV_ROOT}/versions/3.3.3)
* venv27 --> ${PYENV_ROOT}/versions/2.7.6/envs/venv27 (set by PYENV_VERSION)
  venv33 --> ${PYENV_ROOT}/versions/3.3.3/envs/venv33
OUT

  unstub pyenv-version-name
  unstub pyenv-version-origin
}

@test "completions output" {
  create_m_venv "2.7.6" "venv27"
  create_m_venv "3.3.3" "venv33"

  run pyenv-virtualenvs --complete

  assert_success
  assert_output <<OUT
--bare
--skip-aliases
OUT
}
