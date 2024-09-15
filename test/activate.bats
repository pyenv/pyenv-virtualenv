#!/usr/bin/env bats

load test_helper

setup() {
  export HOME="${TMP}"
  export PYENV_ROOT="${TMP}/pyenv"
  unset PYENV_VERSION
  unset PYENV_ACTIVATE_SHELL
  unset VIRTUAL_ENV
  unset CONDA_DEFAULT_ENV
  unset PYTHONHOME
  unset _OLD_VIRTUAL_PYTHONHOME
  unset PYENV_VIRTUALENV_VERBOSE_ACTIVATE
  unset PYENV_VIRTUALENV_DISABLE_PROMPT
  unset PYENV_VIRTUAL_ENV_DISABLE_PROMPT
  unset VIRTUAL_ENV_DISABLE_PROMPT
  unset PYENV_VIRTUALENV_PROMPT
  unset _OLD_VIRTUAL_PS1
  stub pyenv-hooks "activate : echo"
}

@test "activate virtualenv from current version" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(venv) \${PS1:-}";
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "activate virtualenv from current version with custom prompt" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="venv" PYENV_VIRTUALENV_PROMPT='venv:{venv}' run pyenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="venv:venv \${PS1:-}";
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "activate virtualenv from current version (quiet)" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate --quiet

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(venv) \${PS1:-}";
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "activate virtualenv from current version (verbose)" {
  export PYENV_VIRTUALENV_INIT=1
  export PYENV_VIRTUALENV_VERBOSE_ACTIVATE=1

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate --verbose

  assert_success
  assert_output <<EOS
deactivated
pyenv-virtualenv: activate venv
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(venv) \${PS1:-}";
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "activate virtualenv from current version (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VERSION="venv";
export PYENV_ACTIVATE_SHELL=1;
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(venv) \${PS1:-}";
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "activate virtualenv from current version (fish)" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="fish" PYENV_VERSION="venv" run pyenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
set -gx PYENV_VIRTUAL_ENV "${PYENV_ROOT}/versions/venv";
set -gx VIRTUAL_ENV "${PYENV_ROOT}/versions/venv";
functions -e _pyenv_old_prompt              # remove old prompt function if exists. 
                                            # since everything is in memory, it's safe to
                                            # remove it.
functions -c fish_prompt _pyenv_old_prompt  # backup old prompt function

# from python-venv
function fish_prompt
    set -l prompt (_pyenv_old_prompt)       # call old prompt function first since it might 
                                            # read exit status
    echo -n "(venv) "                    # add virtualenv to prompt
    string join -- \n \$prompt              # handle multiline prompts
end
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "activate virtualenv from current version (fish) (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  stub pyenv-version-name "echo venv"
  stub pyenv-virtualenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-prefix "venv : echo \"${PYENV_ROOT}/versions/venv\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="fish" PYENV_VERSION="venv" run pyenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
set -gx PYENV_VERSION "venv";
set -gx PYENV_ACTIVATE_SHELL 1;
set -gx PYENV_VIRTUAL_ENV "${PYENV_ROOT}/versions/venv";
set -gx VIRTUAL_ENV "${PYENV_ROOT}/versions/venv";
functions -e _pyenv_old_prompt              # remove old prompt function if exists. 
                                            # since everything is in memory, it's safe to
                                            # remove it.
functions -c fish_prompt _pyenv_old_prompt  # backup old prompt function

# from python-venv
function fish_prompt
    set -l prompt (_pyenv_old_prompt)       # call old prompt function first since it might 
                                            # read exit status
    echo -n "(venv) "                    # add virtualenv to prompt
    string join -- \n \$prompt              # handle multiline prompts
end
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "activate virtualenv from command-line argument" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate "venv27"

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VERSION="venv27";
export PYENV_ACTIVATE_SHELL=1;
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv27";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv27";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(venv27) \${PS1:-}";
EOS

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "activate virtualenv from command-line argument (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="venv" run pyenv-sh-activate "venv27"

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VERSION="venv27";
export PYENV_ACTIVATE_SHELL=1;
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv27";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv27";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(venv27) \${PS1:-}";
EOS

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "activate virtualenv from command-line argument (fish)" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="fish" PYENV_VERSION="venv" run pyenv-sh-activate "venv27"

  assert_success
  assert_output <<EOS
deactivated
set -gx PYENV_VERSION "venv27";
set -gx PYENV_ACTIVATE_SHELL 1;
set -gx PYENV_VIRTUAL_ENV "${PYENV_ROOT}/versions/venv27";
set -gx VIRTUAL_ENV "${PYENV_ROOT}/versions/venv27";
functions -e _pyenv_old_prompt              # remove old prompt function if exists. 
                                            # since everything is in memory, it's safe to
                                            # remove it.
functions -c fish_prompt _pyenv_old_prompt  # backup old prompt function

# from python-venv
function fish_prompt
    set -l prompt (_pyenv_old_prompt)       # call old prompt function first since it might 
                                            # read exit status
    echo -n "(venv27) "                    # add virtualenv to prompt
    string join -- \n \$prompt              # handle multiline prompts
end
EOS

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "activate virtualenv from command-line argument (fish) (without pyenv-virtualenv-init)" {
  export PYENV_VIRTUALENV_INIT=

  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="fish" PYENV_VERSION="venv" run pyenv-sh-activate "venv27"

  assert_success
  assert_output <<EOS
deactivated
set -gx PYENV_VERSION "venv27";
set -gx PYENV_ACTIVATE_SHELL 1;
set -gx PYENV_VIRTUAL_ENV "${PYENV_ROOT}/versions/venv27";
set -gx VIRTUAL_ENV "${PYENV_ROOT}/versions/venv27";
functions -e _pyenv_old_prompt              # remove old prompt function if exists. 
                                            # since everything is in memory, it's safe to
                                            # remove it.
functions -c fish_prompt _pyenv_old_prompt  # backup old prompt function

# from python-venv
function fish_prompt
    set -l prompt (_pyenv_old_prompt)       # call old prompt function first since it might 
                                            # read exit status
    echo -n "(venv27) "                    # add virtualenv to prompt
    string join -- \n \$prompt              # handle multiline prompts
end
EOS

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
}

@test "unset invokes deactivate" {
  export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"
  export PYENV_ACTIVATE_SHELL=

  stub pyenv-sh-deactivate " : echo deactivated"

  run pyenv-sh-activate --unset

  assert_success
  assert_output <<EOS
deactivated
EOS

  unstub pyenv-sh-deactivate
}

@test "should fail if the version is not a virtualenv" {
  stub pyenv-virtualenv-prefix "3.3.3 : false"
  stub pyenv-version-name " : echo 3.3.3"
  stub pyenv-virtualenv-prefix "3.3.3/envs/3.3.3 : false"

  run pyenv-sh-activate "3.3.3"

  assert_failure
  assert_output <<EOS
pyenv-virtualenv: version \`3.3.3' is not a virtualenv
false
EOS

  unstub pyenv-virtualenv-prefix
  unstub pyenv-version-name
}

@test "should fail if the version is not a virtualenv (quiet)" {
  stub pyenv-virtualenv-prefix "3.3.3 : false"
  stub pyenv-version-name " : echo 3.3.3"
  stub pyenv-virtualenv-prefix "3.3.3/envs/3.3.3 : false"

  run pyenv-sh-activate --quiet "3.3.3"

  assert_failure
  assert_output <<EOS
false
EOS

  unstub pyenv-virtualenv-prefix
  unstub pyenv-version-name
}

@test "should fail if there are multiple versions" {
  stub pyenv-virtualenv-prefix "venv : true"
  stub pyenv-virtualenv-prefix "venv27 : true"

  run pyenv-sh-activate "venv" "venv27"

  assert_failure
  assert_output <<EOS
pyenv-virtualenv: cannot activate multiple versions at once: venv venv27
false
EOS

  unstub pyenv-virtualenv-prefix
}

@test "should fail if there are multiple virtualenvs (quiet)" {
  stub pyenv-virtualenv-prefix "venv : true"
  stub pyenv-virtualenv-prefix "venv27 : true"

  run pyenv-sh-activate --quiet "venv" "venv27"

  assert_failure
  assert_output <<EOS
false
EOS

  unstub pyenv-virtualenv-prefix
}

@test "should fail if the first version is not a virtualenv" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-virtualenv-prefix "2.7.10 : false"
  stub pyenv-version-name " : echo 2.7.10"
  stub pyenv-virtualenv-prefix "2.7.10/envs/2.7.10 : false"

  run pyenv-sh-activate "2.7.10" "venv27"

  assert_failure
  assert_output <<EOS
pyenv-virtualenv: version \`2.7.10' is not a virtualenv
false
EOS

  unstub pyenv-virtualenv-prefix
  unstub pyenv-version-name
}

@test "activate if the first virtualenv is a virtualenv" {
  export PYENV_VIRTUALENV_INIT=1

  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"
  stub pyenv-virtualenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""
  stub pyenv-virtualenv-prefix "2.7.10 : false"
  stub pyenv-prefix "venv27 : echo \"${PYENV_ROOT}/versions/venv27\""

  PYENV_SHELL="bash" run pyenv-sh-activate "venv27" "2.7.10"

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VERSION="venv27:2.7.10";
export PYENV_ACTIVATE_SHELL=1;
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv27";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/venv27";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(venv27) \${PS1:-}";
EOS

  unstub pyenv-sh-deactivate
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
}

@test "do nothing if a 3rd-party virtualenv is active" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${TMP}/venv-3rd-party"
  unset PYENV_VIRTUAL_ENV

  PYENV_SHELL="bash" run pyenv-sh-activate "venv"

  assert_success
  assert_output <<EOS
pyenv-virtualenv: virtualenv \`${TMP}/venv-3rd-party' is already activated
true
EOS
}

@test "do nothing if a 3rd-party virtualenv is active over ours" {
  export PYENV_VIRTUALENV_INIT=1
  export VIRTUAL_ENV="${TMP}/venv-3rd-party"
  export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/venv"

  PYENV_SHELL="bash" run pyenv-sh-activate "venv"

  assert_success
  assert_output <<EOS
pyenv-virtualenv: virtualenv \`${TMP}/venv-3rd-party' is already activated
true
EOS
}

@test "should fail if activate is invoked as a command" {
  run pyenv-activate

  assert_failure
}
