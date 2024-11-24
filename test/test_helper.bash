export TMP="$BATS_TEST_DIRNAME/tmp"

PATH=/usr/bin:/usr/sbin:/bin/:/sbin
PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
PATH="$TMP/bin:$PATH"
export PATH

teardown() {
  rm -fr "$TMP"/*
}

stub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  shift

  export "${prefix}_STUB_PLAN"="${TMP}/${program}-stub-plan"
  export "${prefix}_STUB_RUN"="${TMP}/${program}-stub-run"
  export "${prefix}_STUB_LOG"="${TMP}/${program}-stub-log"
  export "${prefix}_STUB_END"=

  mkdir -p "${TMP}/bin"
  ln -sf "${BATS_TEST_DIRNAME}/stubs/stub" "${TMP}/bin/${program}"

  touch "${TMP}/${program}-stub-plan"
  for arg in "$@"; do printf "%s\n" "$arg" >> "${TMP}/${program}-stub-plan"; done
}

unstub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  local path="${TMP}/bin/${program}"

  export "${prefix}_STUB_END"=1

  local STATUS=0
  "$path" || STATUS="$?"

  rm -f "$path"
  rm -f "${TMP}/${program}-stub-plan" "${TMP}/${program}-stub-run"
  return "$STATUS"
}

assert() {
  if ! "$@"; then
    flunk "failed: $@"
  fi
}

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed "s:${TMP}:\${TMP}:g" >&2
  return 1
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    { echo "command failed with exit status $status"
      echo "output: $output"
    } | flunk
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [ "$status" -eq 0 ]; then
    flunk "expected failed exit status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected:"
      echo "$1"
      echo "actual:"
      echo "$2"
    } | flunk
  fi
}

assert_equal_wildcards() {
  if [[ $1 != $2 ]]; then
    { echo "expected:"
      echo "$2"
      echo "actual:"
      echo "$1"
    } | flunk
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  assert_equal "$expected" "$output"
}

assert_output_wildcards() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  assert_equal_wildcards "$output" "$expected"
}

assert_output_contains() {
  local expected="$1"
  echo "$output" | grep -F "$expected" >/dev/null || {
    { echo "expected output to contain $expected"
      echo "actual: $output"
    } | flunk
  }
}

assert_output_contains_not() {
  local expected="$1"
  echo "$output" | grep -F "$expected" >/dev/null && {
    { echo "expected output to not contain $expected"
      echo "actual: $output"
    } | flunk; return
  }
  return 0
}

create_executable() {
  mkdir -p "${PYENV_ROOT}/versions/$1/bin"
  touch "${PYENV_ROOT}/versions/$1/bin/$2"
  chmod +x "${PYENV_ROOT}/versions/$1/bin/$2"
}

remove_executable() {
  rm -f "${PYENV_ROOT}/versions/$1/bin/$2"
}

setup_version() {
  create_executable "$1" "python"
  remove_executable "$1" "activate"
  remove_executable "$1" "conda"
}

teardown_version() {
  rm -fr "${PYENV_ROOT}/versions/$1"
}

setup_virtualenv() {
  create_executable "$1" "python"
  create_executable "$1" "activate"
  remove_executable "$1" "conda"
}

teardown_virtualenv() {
  rm -fr "${PYENV_ROOT}/versions/$1"
}

setup_m_venv() {
  create_executable "$1" "python"
  create_executable "$1" "activate"
  remove_executable "$1" "conda"
}

teardown_m_venv() {
  rm -fr "${PYENV_ROOT}/versions/$1"
}

setup_conda() {
  create_executable "$1" "python"
  create_executable "$1" "activate"
  create_executable "$1" "conda"
  local conda="$1"
  shift 1
  local env
  for env; do
    create_executable "${conda}/envs/${env}" "python"
    create_executable "${conda}/envs/${env}" "activate"
    create_executable "${conda}/envs/${env}" "conda"
    mkdir -p "${PYENV_ROOT}/versions/${conda}/envs/${env}/etc/conda/activate.d"
    touch "${PYENV_ROOT}/versions/${conda}/envs/${env}/etc/conda/activate.d/activate.sh"
    mkdir -p "${PYENV_ROOT}/versions/${conda}/envs/${env}/etc/conda/deactivate.d"
    touch "${PYENV_ROOT}/versions/${conda}/envs/${env}/etc/conda/deactivate.d/deactivate.sh"
  done
}

teardown_conda() {
  rm -fr "${PYENV_ROOT}/versions/$1"
}

