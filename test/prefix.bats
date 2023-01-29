#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

create_version() {
  mkdir -p "${PYENV_ROOT}/versions/$1/bin"
  touch "${PYENV_ROOT}/versions/$1/bin/python"
  chmod +x "${PYENV_ROOT}/versions/$1/bin/python"
}

remove_version() {
  rm -fr "${PYENV_ROOT}/versions/$1"
}

create_virtualenv() {
  create_version "$1"
  create_version "${2:-$1}"
  mkdir -p "${PYENV_ROOT}/versions/$1/lib/python${2:-$1}"
  echo "${PYENV_ROOT}/versions/${2:-$1}" > "${PYENV_ROOT}/versions/$1/lib/python${2:-$1}/orig-prefix.txt"
  touch "${PYENV_ROOT}/versions/$1/bin/activate"
}

create_virtualenv_jython() {
  create_version "$1"
  create_version "${2:-$1}"
  mkdir -p "${PYENV_ROOT}/versions/$1/Lib/"
  echo "${PYENV_ROOT}/versions/${2:-$1}" > "${PYENV_ROOT}/versions/$1/Lib/orig-prefix.txt"
  touch "${PYENV_ROOT}/versions/$1/bin/activate"
}

create_virtualenv_pypy() {
  create_version "$1"
  create_version "${2:-$1}"
  mkdir -p "${PYENV_ROOT}/versions/$1/lib-python/${2:-$1}"
  echo "${PYENV_ROOT}/versions/${2:-$1}" > "${PYENV_ROOT}/versions/$1/lib-python/${2:-$1}/orig-prefix.txt"
  touch "${PYENV_ROOT}/versions/$1/bin/activate"
}

remove_virtualenv() {
  remove_version "$1"
  remove_version "${2:-$1}"
}

create_m_venv() {
  create_version "$1"
  create_version "${2:-$1}"
  echo "home = ${PYENV_ROOT}/versions/${2:-$1}/bin" > "${PYENV_ROOT}/versions/$1/pyvenv.cfg"
  touch "${PYENV_ROOT}/versions/$1/bin/activate"
}

remove_m_venv() {
  remove_version "${2:-$1}"
}

create_conda() {
  create_version "$1"
  create_version "${2:-$1}"
  touch "${PYENV_ROOT}/versions/$1/bin/conda"
  touch "${PYENV_ROOT}/versions/$1/bin/activate"
  mkdir -p "${PYENV_ROOT}/versions/${2:-$1}/bin"
  touch "${PYENV_ROOT}/versions/${2:-$1}/bin/conda"
  touch "${PYENV_ROOT}/versions/${2:-$1}/bin/activate"
}

remove_conda() {
  remove_version "${2:-$1}"
}

@test "display prefix of virtualenv created by virtualenv" {
  stub pyenv-version-name "echo foo"
  stub pyenv-prefix "foo : echo \"${PYENV_ROOT}/versions/foo\""
  create_virtualenv "foo" "2.7.11"

  PYENV_VERSION="foo" run pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${PYENV_ROOT}/versions/2.7.11
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  remove_virtualenv "foo" "2.7.11"
}

@test "display prefix of virtualenv created by virtualenv (pypy)" {
  stub pyenv-version-name "echo foo"
  stub pyenv-prefix "foo : echo \"${PYENV_ROOT}/versions/foo\""
  create_virtualenv_pypy "foo" "pypy-4.0.1"

  PYENV_VERSION="foo" run pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${PYENV_ROOT}/versions/pypy-4.0.1
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  remove_virtualenv "foo" "pypy-4.0.1"
}

@test "display prefix of virtualenv created by virtualenv (jython)" {
  stub pyenv-version-name "echo foo"
  stub pyenv-prefix "foo : echo \"${PYENV_ROOT}/versions/foo\""
  create_virtualenv_jython "foo" "jython-2.7.0"

  PYENV_VERSION="foo" run pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${PYENV_ROOT}/versions/jython-2.7.0
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  remove_virtualenv "foo" "jython-2.7.0"
}

@test "display prefixes of virtualenv created by virtualenv" {
  stub pyenv-version-name "echo foo:bar"
  stub pyenv-prefix "foo : echo \"${PYENV_ROOT}/versions/foo\"" \
                    "bar : echo \"${PYENV_ROOT}/versions/bar\""
  create_virtualenv "foo" "2.7.11"
  create_virtualenv "bar" "3.5.1"

  PYENV_VERSION="foo:bar" run pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${PYENV_ROOT}/versions/2.7.11:${PYENV_ROOT}/versions/3.5.1
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  remove_virtualenv "foo" "2.7.11"
  remove_virtualenv "bar" "3.5.1"
}

@test "display prefix of virtualenv created by venv" {
  stub pyenv-version-name "echo foo"
  stub pyenv-prefix "foo : echo \"${PYENV_ROOT}/versions/foo\""
  create_m_venv "foo" "3.3.6"

  PYENV_VERSION="foo" run pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${PYENV_ROOT}/versions/3.3.6
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  remove_m_venv "foo" "3.3.6"
}

@test "display prefixes of virtualenv created by venv" {
  stub pyenv-version-name "echo foo:bar"
  stub pyenv-prefix "foo : echo \"${PYENV_ROOT}/versions/foo\"" \
                    "bar : echo \"${PYENV_ROOT}/versions/bar\""
  create_m_venv "foo" "3.3.6"
  create_m_venv "bar" "3.4.4"

  PYENV_VERSION="foo:bar" run pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${PYENV_ROOT}/versions/3.3.6:${PYENV_ROOT}/versions/3.4.4
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  remove_m_venv "foo" "3.3.6"
  remove_m_venv "bar" "3.4.4"
}

@test "display prefix of virtualenv created by conda" {
  stub pyenv-version-name "echo miniconda3-3.16.0/envs/foo"
  stub pyenv-prefix "miniconda3-3.16.0/envs/foo : echo \"${PYENV_ROOT}/versions/miniconda3-3.16.0/envs/foo\""
  create_conda "miniconda3-3.16.0/envs/foo" "miniconda3-3.16.0"

  PYENV_VERSION="miniconda3-3.16.0/envs/foo" run pyenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${PYENV_ROOT}/versions/miniconda3-3.16.0/envs/foo
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  remove_conda "miniconda3-3.16.0/envs/foo" "miniconda3-3.16.0"
}

@test "should fail if the version is the system" {
  stub pyenv-version-name "echo system"

  PYENV_VERSION="system" run pyenv-virtualenv-prefix

  assert_failure
  assert_output <<OUT
pyenv-virtualenv: version \`system' is not a virtualenv
OUT

  unstub pyenv-version-name
}

@test "should fail if the version is not a virtualenv" {
  stub pyenv-version-name "echo 3.4.4"
  stub pyenv-prefix "3.4.4 : echo \"${PYENV_ROOT}/versions/3.4.4\""
  create_version "3.4.4"

  PYENV_VERSION="3.4.4" run pyenv-virtualenv-prefix

  assert_failure
  assert_output <<OUT
pyenv-virtualenv: version \`3.4.4' is not a virtualenv
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  remove_version "3.4.4"
}

@test "should fail if one of the versions is not a virtualenv" {
  stub pyenv-version-name "echo venv33:3.4.4"
  stub pyenv-prefix "venv33 : echo \"${PYENV_ROOT}/versions/venv33\"" \
                    "3.4.4 : echo \"${PYENV_ROOT}/versions/3.4.4\""
  create_virtualenv "venv33" "3.3.6"
  create_version "3.4.4"

  PYENV_VERSION="venv33:3.4.4" run pyenv-virtualenv-prefix

  assert_failure
  assert_output <<OUT
pyenv-virtualenv: version \`3.4.4' is not a virtualenv
OUT

  unstub pyenv-version-name
  unstub pyenv-prefix
  remove_virtualenv "venv33" "3.3.6"
  remove_version "3.4.4"
}
