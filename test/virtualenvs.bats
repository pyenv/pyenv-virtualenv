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

@test "skip aliases for versions that are not virtual environments" {
  stub pyenv-version-name ": echo system"

  create_m_venv "3.12.1" "venv312"
  # an alias for a Pyenv-installed version
  setup_version "3.11.9"
  ln -s "3.11.9" "${PYENV_ROOT}/versions/3.11"
  # a link to an outside Python installation, like those created by `brew pyenv-sync`
  mkdir -p "${TMP}/external/bin"
  touch "${TMP}/external/bin/python"
  ln -s "${TMP}/external" "${PYENV_ROOT}/versions/3.13"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  3.12.1/envs/venv312 (created from ${PYENV_ROOT}/versions/3.12.1)
  venv312 --> ${PYENV_ROOT}/versions/3.12.1/envs/venv312
OUT

  run pyenv-virtualenvs --bare

  assert_success
  assert_output <<OUT
3.12.1/envs/venv312
venv312
OUT

  unstub pyenv-version-name
}

@test "list aliases for virtual environments outside the versions directory" {
  stub pyenv-version-name ": echo system" ": echo system"

  mkdir -p "${TMP}/external/bin"
  touch "${TMP}/external/bin/activate"
  mkdir -p "${PYENV_ROOT}/versions"
  ln -s "${TMP}/external" "${PYENV_ROOT}/versions/external"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  external --> ${TMP}/external
OUT

  run pyenv-virtualenvs --skip-aliases

  assert_success
  assert_output ""

  unstub pyenv-version-name
}

@test "list conda environments linked from the versions directory" {
  setup_conda "miniconda3-latest"
  # Conda 4.4+ doesn't put the `activate' script into environments
  create_executable "miniconda3-latest/envs/foo" "python"
  mkdir -p "${PYENV_ROOT}/versions/miniconda3-latest/envs/foo/conda-meta"
  ln -s "${PYENV_ROOT}/versions/miniconda3-latest/envs/foo" "${PYENV_ROOT}/versions/foo"

  run pyenv-virtualenvs --bare

  assert_success
  assert_output <<OUT
miniconda3-latest/envs/foo
foo
miniconda3-latest
OUT
}

@test "list virtual environments whose base installation cannot be determined" {
  stub pyenv-version-name ": echo system"

  create_m_venv "3.12.1" "venv312"
  # `python' is gone, e.g. its symlink target was removed
  create_m_venv "3.12.1" "broken"
  remove_executable "3.12.1/envs/broken" "python"

  run pyenv-virtualenvs

  assert_success
  assert_output <<OUT
  3.12.1/envs/broken
  3.12.1/envs/venv312 (created from ${PYENV_ROOT}/versions/3.12.1)
  broken --> ${PYENV_ROOT}/versions/3.12.1/envs/broken
  venv312 --> ${PYENV_ROOT}/versions/3.12.1/envs/venv312
OUT

  unstub pyenv-version-name
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
