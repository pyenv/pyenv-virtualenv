#!/usr/bin/env bats

load test_helper

setup() {
  export HOME="${TMP}"
  export PYENV_ROOT="${TMP}/pyenv"
}

@test "activate virtualenv from current version" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
unset PYENV_DEACTIVATE;
export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv";
source "\${PYENV_ACTIVATE}/bin/activate";
EOS
}

@test "activate virtualenv from current version (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
pyenv shell "venv";
unset PYENV_DEACTIVATE;
export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv";
source "\${PYENV_ACTIVATE}/bin/activate";
EOS
}

@test "activate virtualenv from current version (fish)" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""

  PYENV_SHELL="fish" PYENV_VERSION="venv" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
set -e PYENV_DEACTIVATE;
setenv PYENV_ACTIVATE "${PYENV_ROOT}/versions/venv";
. "\${PYENV_ACTIVATE}/bin/activate.fish";
EOS
}

@test "activate virtualenv from current version (fish) (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""

  PYENV_SHELL="fish" PYENV_VERSION="venv" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
pyenv shell "venv";
set -e PYENV_DEACTIVATE;
setenv PYENV_ACTIVATE "${PYENV_ROOT}/versions/venv";
. "\${PYENV_ACTIVATE}/bin/activate.fish";
EOS
}

@test "activate virtualenv from command-line argument" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""

  run pyenv-sh-activate "venv27"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
pyenv shell "venv27";
unset PYENV_DEACTIVATE;
export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv27";
source "\${PYENV_ACTIVATE}/bin/activate";
EOS
}

@test "activate virtualenv from command-line argument (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""

  run pyenv-sh-activate "venv27"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
pyenv shell "venv27";
unset PYENV_DEACTIVATE;
export PYENV_ACTIVATE="${PYENV_ROOT}/versions/venv27";
source "\${PYENV_ACTIVATE}/bin/activate";
EOS
}

@test "unset invokes deactivate" {
  run pyenv-sh-activate --unset

  assert_success
  assert_output <<EOS
pyenv deactivate
EOS
}

@test "should fail if the version is not a virtualenv" {
  stub pyenv-virtualenv-prefix "3.3.3 : false"

  run pyenv-sh-activate "3.3.3"

  unstub pyenv-virtualenv-prefix

  assert_failure
}

@test "should fail if there are multiple versions" {
  run pyenv-sh-activate "venv" "venv27"

  assert_failure
  assert_output <<EOS
pyenv-virtualenv: cannot activate multiple versions at once: venv venv27
EOS
}

@test "should fail if activate is invoked as a command" {
  run pyenv-activate

  assert_failure
}
