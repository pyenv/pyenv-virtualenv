#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "reset virtualenv by symlink" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv312"
  ln -fs "${PYENV_ROOT}/versions/3.12.3/envs/venv312" "${PYENV_ROOT}/versions/venv312"

  stub pyenv-virtualenv-prefix "3.12.3/envs/venv312 : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete "-f 3.12.3/envs/venv312 : echo deleted \$2"
  stub pyenv-virtualenv "3.12.3 venv312 : echo created \$2 from \$1"

  run pyenv-virtualenv-reset -f "venv312"

  assert_success
  assert_output <<OUT
deleted 3.12.3/envs/venv312
created venv312 from 3.12.3
OUT

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "reset virtualenv by long name" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv312"
  ln -fs "${PYENV_ROOT}/versions/3.12.3/envs/venv312" "${PYENV_ROOT}/versions/venv312"

  stub pyenv-virtualenv-prefix "3.12.3/envs/venv312 : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete "-f 3.12.3/envs/venv312 : echo deleted \$2"
  stub pyenv-virtualenv "3.12.3 venv312 : echo created \$2 from \$1"

  run pyenv-virtualenv-reset --force "3.12.3/envs/venv312"

  assert_success
  assert_output <<OUT
deleted 3.12.3/envs/venv312
created venv312 from 3.12.3
OUT

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "reset virtualenv by long name without symlink" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv312"

  stub pyenv-virtualenv-prefix "3.12.3/envs/venv312 : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete "-f 3.12.3/envs/venv312 : echo deleted \$2"
  stub pyenv-virtualenv "3.12.3 venv312 : echo created \$2 from \$1"

  run pyenv-virtualenv-reset -f "3.12.3/envs/venv312"

  assert_success
  assert_output <<OUT
deleted 3.12.3/envs/venv312
created venv312 from 3.12.3
OUT

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "reset current virtualenv" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv312"
  ln -fs "${PYENV_ROOT}/versions/3.12.3/envs/venv312" "${PYENV_ROOT}/versions/venv312"

  stub pyenv-version-name "echo venv312"
  stub pyenv-virtualenv-prefix "3.12.3/envs/venv312 : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete "-f 3.12.3/envs/venv312 : echo deleted \$2"
  stub pyenv-virtualenv "3.12.3 venv312 : echo created \$2 from \$1"

  run pyenv-virtualenv-reset -f

  assert_success
  assert_output <<OUT
deleted 3.12.3/envs/venv312
created venv312 from 3.12.3
OUT

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "reset first of multiple current versions" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv312"
  ln -fs "${PYENV_ROOT}/versions/3.12.3/envs/venv312" "${PYENV_ROOT}/versions/venv312"

  stub pyenv-version-name "echo venv312:3.11.9"
  stub pyenv-virtualenv-prefix "3.12.3/envs/venv312 : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete "-f 3.12.3/envs/venv312 : echo deleted \$2"
  stub pyenv-virtualenv "3.12.3 venv312 : echo created \$2 from \$1"

  run pyenv-virtualenv-reset -f

  assert_success
  assert_output <<OUT
deleted 3.12.3/envs/venv312
created venv312 from 3.12.3
OUT

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "reset virtualenv created from system" {
  mkdir -p "${PYENV_ROOT}/versions/venv"

  stub pyenv-virtualenv-prefix "venv : echo /usr"
  stub pyenv-virtualenv-delete "-f venv : echo deleted \$2"
  stub pyenv-virtualenv "system venv : echo created \$2 from \$1"

  run pyenv-virtualenv-reset -f "venv"

  assert_success
  assert_output <<OUT
deleted venv
created venv from system
OUT

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "reset virtualenv created directly in versions directory" {
  mkdir -p "${PYENV_ROOT}/versions/2.7.18"
  mkdir -p "${PYENV_ROOT}/versions/venv27"

  stub pyenv-virtualenv-prefix "venv27 : echo '${PYENV_ROOT}/versions/2.7.18'"
  stub pyenv-virtualenv-delete "-f venv27 : echo deleted \$2"
  stub pyenv-virtualenv "2.7.18 venv27 : echo created \$2 from \$1"

  run pyenv-virtualenv-reset -f "venv27"

  assert_success
  assert_output <<OUT
deleted venv27
created venv27 from 2.7.18
OUT

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "reset conda environment" {
  mkdir -p "${PYENV_ROOT}/versions/miniconda3-latest/envs/foo"

  stub pyenv-virtualenv-prefix "miniconda3-latest/envs/foo : echo '${PYENV_ROOT}/versions/miniconda3-latest'"
  stub pyenv-virtualenv-delete "-f miniconda3-latest/envs/foo : echo deleted \$2"
  stub pyenv-virtualenv "miniconda3-latest foo : echo created \$2 from \$1"

  run pyenv-virtualenv-reset -f "miniconda3-latest/envs/foo"

  assert_success
  assert_output <<OUT
deleted miniconda3-latest/envs/foo
created foo from miniconda3-latest
OUT

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "reset virtualenv with system site packages" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv312"
  cat > "${PYENV_ROOT}/versions/3.12.3/envs/venv312/pyvenv.cfg" <<OUT
home = ${PYENV_ROOT}/versions/3.12.3/bin
include-system-site-packages = true
version = 3.12.3
OUT

  stub pyenv-virtualenv-prefix "3.12.3/envs/venv312 : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete "-f 3.12.3/envs/venv312 : echo deleted \$2"
  stub pyenv-virtualenv "--system-site-packages 3.12.3 venv312 : echo created \$3 from \$2 with \$1"

  run pyenv-virtualenv-reset -f "3.12.3/envs/venv312"

  assert_success
  assert_output <<OUT
deleted 3.12.3/envs/venv312
created venv312 from 3.12.3 with --system-site-packages
OUT

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "reset virtualenv without system site packages" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv312"
  cat > "${PYENV_ROOT}/versions/3.12.3/envs/venv312/pyvenv.cfg" <<OUT
home = ${PYENV_ROOT}/versions/3.12.3/bin
include-system-site-packages = false
version = 3.12.3
OUT

  stub pyenv-virtualenv-prefix "3.12.3/envs/venv312 : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete "-f 3.12.3/envs/venv312 : echo deleted \$2"
  stub pyenv-virtualenv "3.12.3 venv312 : echo created \$2 from \$1"

  run pyenv-virtualenv-reset -f "3.12.3/envs/venv312"

  assert_success
  assert_output <<OUT
deleted 3.12.3/envs/venv312
created venv312 from 3.12.3
OUT

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "reset virtualenv after confirmation" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv312"

  stub pyenv-virtualenv-prefix "3.12.3/envs/venv312 : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete "-f 3.12.3/envs/venv312 : echo deleted \$2"
  stub pyenv-virtualenv "3.12.3 venv312 : echo created \$2 from \$1"

  run pyenv-virtualenv-reset "3.12.3/envs/venv312" <<<"y"

  assert_success
  assert_output <<OUT
deleted 3.12.3/envs/venv312
created venv312 from 3.12.3
OUT

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "not reset virtualenv when declined" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv312"

  stub pyenv-virtualenv-prefix "3.12.3/envs/venv312 : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete
  stub pyenv-virtualenv

  run pyenv-virtualenv-reset "3.12.3/envs/venv312" <<<"n"

  assert_failure

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv

  [ -d "${PYENV_ROOT}/versions/3.12.3/envs/venv312" ]
}

@test "not reset nonexistent virtualenv" {
  stub pyenv-virtualenv-delete
  stub pyenv-virtualenv

  run pyenv-virtualenv-reset -f "venv312"

  assert_failure
  assert_output "pyenv-virtualenv: virtualenv \`venv312' not installed"

  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "not reset version which is not a virtualenv" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3"

  stub pyenv-virtualenv-prefix "3.12.3 : false"
  stub pyenv-virtualenv-delete
  stub pyenv-virtualenv

  run pyenv-virtualenv-reset -f "3.12.3"

  assert_failure
  assert_output "pyenv-virtualenv: \`3.12.3' is not a virtualenv."

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv

  [ -d "${PYENV_ROOT}/versions/3.12.3" ]
}

@test "not reset system version" {
  stub pyenv-version-name "echo system"
  stub pyenv-virtualenv-delete
  stub pyenv-virtualenv

  run pyenv-virtualenv-reset -f

  assert_failure
  assert_output "pyenv-virtualenv: \`system' is not a virtualenv."

  unstub pyenv-version-name
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv
}

@test "not reset conda root environment" {
  mkdir -p "${PYENV_ROOT}/versions/miniconda3-latest"

  stub pyenv-virtualenv-prefix "miniconda3-latest : echo '${PYENV_ROOT}/versions/miniconda3-latest'"
  stub pyenv-virtualenv-delete
  stub pyenv-virtualenv

  run pyenv-virtualenv-reset -f "miniconda3-latest"

  assert_failure
  assert_output "pyenv-virtualenv: \`miniconda3-latest' is not a virtualenv."

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv

  [ -d "${PYENV_ROOT}/versions/miniconda3-latest" ]
}

@test "not reset virtualenv whose short name refers to another virtualenv" {
  mkdir -p "${PYENV_ROOT}/versions/3.11.9/envs/venv"
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv"
  ln -fs "${PYENV_ROOT}/versions/3.11.9/envs/venv" "${PYENV_ROOT}/versions/venv"

  stub pyenv-virtualenv-prefix "3.12.3/envs/venv : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete
  stub pyenv-virtualenv

  run pyenv-virtualenv-reset -f "3.12.3/envs/venv"

  assert_failure
  assert_output "pyenv-virtualenv: cannot reset \`3.12.3/envs/venv': \`${PYENV_ROOT}/versions/venv' refers to another location."

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv

  [ -d "${PYENV_ROOT}/versions/3.12.3/envs/venv" ]
}

@test "not reset virtualenv whose short name is taken by another version" {
  mkdir -p "${PYENV_ROOT}/versions/3.12.3/envs/venv"
  mkdir -p "${PYENV_ROOT}/versions/venv"

  stub pyenv-virtualenv-prefix "3.12.3/envs/venv : echo '${PYENV_ROOT}/versions/3.12.3'"
  stub pyenv-virtualenv-delete
  stub pyenv-virtualenv

  run pyenv-virtualenv-reset -f "3.12.3/envs/venv"

  assert_failure
  assert_output "pyenv-virtualenv: cannot reset \`3.12.3/envs/venv': \`${PYENV_ROOT}/versions/venv' already exists."

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv

  [ -d "${PYENV_ROOT}/versions/3.12.3/envs/venv" ]
}

@test "not reset virtualenv whose base version is not installed" {
  mkdir -p "${PYENV_ROOT}/versions/venv27"

  stub pyenv-virtualenv-prefix "venv27 : echo '${PYENV_ROOT}/versions/2.7.18'"
  stub pyenv-virtualenv-delete
  stub pyenv-virtualenv

  run pyenv-virtualenv-reset -f "venv27"

  assert_failure
  assert_output "pyenv-virtualenv: cannot reset \`venv27': \`2.7.18' is not installed in pyenv."

  unstub pyenv-virtualenv-prefix
  unstub pyenv-virtualenv-delete
  unstub pyenv-virtualenv

  [ -d "${PYENV_ROOT}/versions/venv27" ]
}
