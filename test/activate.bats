#!/usr/bin/env bats

load test_helper

setup() {
  export HOME="${TMP}"
  export PYENV_ROOT="${TMP}/pyenv"
  unset PYENV_VERSION
  unset PYENV_ACTIVATE_SHELL
  unset PYENV_DEACTIVATE
  unset VIRTUAL_ENV
  unset CONDA_DEFAULT_ENV
  unset PYTHONHOME
  unset _OLD_VIRTUAL_PYTHONHOME
  unset PYENV_VIRTUALENV_DISABLE_PROMPT
  unset PYENV_VIRTUAL_ENV_DISABLE_PROMPT
  unset VIRTUAL_ENV_DISABLE_PROMPT
  unset _OLD_VIRTUAL_PS1
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
false
pyenv-virtualenv: activate venv
unset PYENV_DEACTIVATE;
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
pyenv-virtualenv: prompt changing will be removed from future release. configure \`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv) \${PS1}";
EOS
}

@test "activate virtualenv from current version (verbose)" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate --verbose

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
false
pyenv-virtualenv: activate venv
unset PYENV_DEACTIVATE;
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
pyenv-virtualenv: prompt changing will be removed from future release. configure \`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv) \${PS1}";
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
# Load pyenv-virtualenv automatically by adding
# the following to ~/.bash_profile:

eval "\$(pyenv virtualenv-init -)"

false
pyenv-virtualenv: activate venv
export PYENV_VERSION="venv";
export PYENV_ACTIVATE_SHELL=1;
unset PYENV_DEACTIVATE;
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
pyenv-virtualenv: prompt changing will be removed from future release. configure \`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv) \${PS1}";
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
false
pyenv-virtualenv: activate venv
set -e PYENV_DEACTIVATE;
setenv VIRTUAL_ENV "${PYENV_ROOT}/versions/venv";
pyenv-virtualenv: prompt changing not work for fish.
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
# Load pyenv-virtualenv automatically by adding
# the following to ~/.config/fish/config.fish:

status --is-interactive; and . (pyenv virtualenv-init -|psub)

false
pyenv-virtualenv: activate venv
setenv PYENV_VERSION "venv";
setenv PYENV_ACTIVATE_SHELL 1;
set -e PYENV_DEACTIVATE;
setenv VIRTUAL_ENV "${PYENV_ROOT}/versions/venv";
pyenv-virtualenv: prompt changing not work for fish.
EOS
}

@test "activate virtualenv from command-line argument" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate "venv27"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
false
pyenv-virtualenv: activate venv27
export PYENV_VERSION="venv27";
export PYENV_ACTIVATE_SHELL=1;
unset PYENV_DEACTIVATE;
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv27";
pyenv-virtualenv: prompt changing will be removed from future release. configure \`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv27) \${PS1}";
EOS
}

@test "activate virtualenv from command-line argument (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate "venv27"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
# Load pyenv-virtualenv automatically by adding
# the following to ~/.bash_profile:

eval "\$(pyenv virtualenv-init -)"

false
pyenv-virtualenv: activate venv27
export PYENV_VERSION="venv27";
export PYENV_ACTIVATE_SHELL=1;
unset PYENV_DEACTIVATE;
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv27";
pyenv-virtualenv: prompt changing will be removed from future release. configure \`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv27) \${PS1}";
EOS
}

@test "activate virtualenv from command-line argument (fish)" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""

  PYENV_SHELL="fish" PYENV_VERSION="venv" run pyenv-sh-activate "venv27"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
false
pyenv-virtualenv: activate venv27
setenv PYENV_VERSION "venv27";
setenv PYENV_ACTIVATE_SHELL 1;
set -e PYENV_DEACTIVATE;
setenv VIRTUAL_ENV "${PYENV_ROOT}/versions/venv27";
pyenv-virtualenv: prompt changing not work for fish.
EOS
}

@test "activate virtualenv from command-line argument (fish) (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""

  PYENV_SHELL="fish" PYENV_VERSION="venv" run pyenv-sh-activate "venv27"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
# Load pyenv-virtualenv automatically by adding
# the following to ~/.config/fish/config.fish:

status --is-interactive; and . (pyenv virtualenv-init -|psub)

false
pyenv-virtualenv: activate venv27
setenv PYENV_VERSION "venv27";
setenv PYENV_ACTIVATE_SHELL 1;
set -e PYENV_DEACTIVATE;
setenv VIRTUAL_ENV "${PYENV_ROOT}/versions/venv27";
pyenv-virtualenv: prompt changing not work for fish.
EOS
}

@test "unset invokes deactivate" {
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  stub pyenv-sh-deactivate "echo deactivated"

  run pyenv-sh-activate --unset

  unstub pyenv-sh-deactivate

  assert_success
  assert_output <<EOS
deactivated
EOS
}

@test "should fail if the version is not a virtualenv" {
  stub pyenv-virtualenv-prefix "3.3.3 : false"

  run pyenv-sh-activate "3.3.3"

  unstub pyenv-virtualenv-prefix

  assert_failure
  assert_output <<EOS
pyenv-virtualenv: version \`3.3.3' is not a virtualenv
false
EOS
}

@test "should fail if the version is not a virtualenv (quiet)" {
  stub pyenv-virtualenv-prefix "3.3.3 : false"

  run pyenv-sh-activate --quiet "3.3.3"

  unstub pyenv-virtualenv-prefix

  assert_failure
  assert_output <<EOS
false
EOS
}

@test "should fail if there are multiple versions" {
  stub pyenv-virtualenv-prefix "venv : true"
  stub pyenv-virtualenv-prefix "venv27 : true"

  run pyenv-sh-activate "venv" "venv27"

  unstub pyenv-virtualenv-prefix

  assert_failure
  assert_output <<EOS
pyenv-virtualenv: cannot activate multiple versions at once: venv venv27
false
EOS
}

@test "should fail if there are multiple virtualenvs (quiet)" {
  stub pyenv-virtualenv-prefix "venv : true"
  stub pyenv-virtualenv-prefix "venv27 : true"

  run pyenv-sh-activate --quiet "venv" "venv27"

  unstub pyenv-virtualenv-prefix

  assert_failure
  assert_output <<EOS
false
EOS
}

@test "should fail if the first version is not a virtualenv" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-virtualenv-prefix "2.7.10 : false"

  run pyenv-sh-activate "2.7.10" "venv27"

  unstub pyenv-virtualenv-prefix

  assert_failure
  assert_output <<EOS
pyenv-virtualenv: version \`2.7.10' is not a virtualenv
false
EOS
}

@test "activate if the first virtualenv is a virtualenv" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-virtualenv-prefix "2.7.10 : false"
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""

  run pyenv-sh-activate "venv27" "2.7.10"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
false
pyenv-virtualenv: activate venv27
export PYENV_VERSION="venv27:2.7.10";
export PYENV_ACTIVATE_SHELL=1;
unset PYENV_DEACTIVATE;
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv27";
pyenv-virtualenv: prompt changing will be removed from future release. configure \`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv27) \${PS1}";
EOS
}

@test "should fail if activate is invoked as a command" {
  run pyenv-activate

  assert_failure
}
