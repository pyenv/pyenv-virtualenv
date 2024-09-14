#!/usr/bin/env bats

load test_helper

setup() {
  export HOME="${TMP}"
  export PYENV_ROOT="${TMP}/pyenv"
  unset PYENV_VERSION
  unset PYENV_ACTIVATE_SHELL
  unset PYENV_VIRTUAL_ENV
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

teardown() {
  unstub pyenv-hooks
}

@test "activate conda root from current version" {
  export PYENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0"
  stub pyenv-version-name "echo anaconda-2.3.0"
  stub pyenv-virtualenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0" run pyenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0";
export CONDA_DEFAULT_ENV="root";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(anaconda-2.3.0) \${PS1:-}";
export CONDA_PREFIX="${TMP}/pyenv/versions/anaconda-2.3.0";
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
  teardown_conda "anaconda-2.3.0"
}

@test "activate conda root from current version with custom prompt" {
  export PYENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0"
  stub pyenv-version-name "echo anaconda-2.3.0"
  stub pyenv-virtualenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0" PYENV_VIRTUALENV_PROMPT='venv:{venv}' run pyenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0";
export CONDA_DEFAULT_ENV="root";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="venv:anaconda-2.3.0 \${PS1:-}";
export CONDA_PREFIX="${TMP}/pyenv/versions/anaconda-2.3.0";
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
  teardown_conda "anaconda-2.3.0"
}

@test "activate conda root from current version (fish)" {
  export PYENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0"
  stub pyenv-version-name "echo anaconda-2.3.0"
  stub pyenv-virtualenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="fish" PYENV_VERSION="anaconda-2.3.0" run pyenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
set -gx PYENV_VIRTUAL_ENV "${TMP}/pyenv/versions/anaconda-2.3.0";
set -gx VIRTUAL_ENV "${TMP}/pyenv/versions/anaconda-2.3.0";
set -gx CONDA_DEFAULT_ENV "root";
functions -e _pyenv_old_prompt              # remove old prompt function if exists. 
                                            # since everything is in memory, it's safe to
                                            # remove it.
functions -c fish_prompt _pyenv_old_prompt  # backup old prompt function

# from python-venv
function fish_prompt
    set -l prompt (_pyenv_old_prompt)       # call old prompt function first since it might 
                                            # read exit status
    echo -n "(anaconda-2.3.0) "                    # add virtualenv to prompt
    string join -- \n \$prompt              # handle multiline prompts
end
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
  teardown_conda "anaconda-2.3.0"
}

@test "activate conda root from command-line argument" {
  export PYENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0"
  setup_conda "miniconda-3.9.1"
  stub pyenv-virtualenv-prefix "miniconda-3.9.1 : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1\""
  stub pyenv-prefix "miniconda-3.9.1 : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0" run pyenv-sh-activate "miniconda-3.9.1"

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VERSION="miniconda-3.9.1";
export PYENV_ACTIVATE_SHELL=1;
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/miniconda-3.9.1";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/miniconda-3.9.1";
export CONDA_DEFAULT_ENV="root";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(miniconda-3.9.1) \${PS1:-}";
export CONDA_PREFIX="${TMP}/pyenv/versions/miniconda-3.9.1";
EOS

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
  teardown_conda "anaconda-2.3.0"
  teardown_conda "miniconda-3.9.1"
}

@test "activate conda env from current version" {
  export PYENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0" "foo"
  stub pyenv-version-name "echo anaconda-2.3.0/envs/foo"
  stub pyenv-virtualenv-prefix "anaconda-2.3.0/envs/foo : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""
  stub pyenv-prefix "anaconda-2.3.0/envs/foo : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0/envs/foo" run pyenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo";
export CONDA_DEFAULT_ENV="foo";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(anaconda-2.3.0/envs/foo) \${PS1:-}";
export CONDA_PREFIX="${TMP}/pyenv/versions/anaconda-2.3.0/envs/foo";
. "${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo/etc/conda/activate.d/activate.sh";
EOS

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
  teardown_conda "anaconda-2.3.0" "foo"
}

@test "activate conda env from command-line argument" {
  export PYENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0" "foo"
  setup_conda "miniconda-3.9.1" "bar"
  stub pyenv-virtualenv-prefix "miniconda-3.9.1/envs/bar : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1\""
  stub pyenv-prefix "miniconda-3.9.1/envs/bar : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar\""
  stub pyenv-sh-deactivate "--force --quiet : echo deactivated"

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0/envs/foo" run pyenv-sh-activate "miniconda-3.9.1/envs/bar"

  assert_success
  assert_output <<EOS
deactivated
export PYENV_VERSION="miniconda-3.9.1/envs/bar";
export PYENV_ACTIVATE_SHELL=1;
export PYENV_VIRTUAL_ENV="${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar";
export VIRTUAL_ENV="${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar";
export CONDA_DEFAULT_ENV="bar";
export _OLD_VIRTUAL_PS1="\${PS1:-}";
export PS1="(miniconda-3.9.1/envs/bar) \${PS1:-}";
export CONDA_PREFIX="${TMP}/pyenv/versions/miniconda-3.9.1/envs/bar";
. "${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar/etc/conda/activate.d/activate.sh";
EOS

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix
  unstub pyenv-sh-deactivate
  teardown_conda "anaconda-2.3.0" "foo"
  teardown_conda "miniconda-3.9.1" "bar"
}
