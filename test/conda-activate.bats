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
  unset PYENV_VIRTUALENV_DISABLE_PROMPT
  unset PYENV_VIRTUAL_ENV_DISABLE_PROMPT
  unset VIRTUAL_ENV_DISABLE_PROMPT
  unset _OLD_VIRTUAL_PS1
}

@test "activate conda root from current version" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "anaconda-2.3.0"
  stub pyenv-version-name "echo anaconda-2.3.0"
  stub pyenv-virtualenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
false
pyenv-virtualenv: activate anaconda-2.3.0
export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0";
export CONDA_DEFAULT_ENV="root";
pyenv-virtualenv: prompt changing will be removed from future release. configure \`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(anaconda-2.3.0) \${PS1}";
EOS
}

@test "activate conda root from current version (fish)" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "anaconda-2.3.0"
  stub pyenv-version-name "echo anaconda-2.3.0"
  stub pyenv-virtualenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""
  stub pyenv-prefix "anaconda-2.3.0 : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0\""

  PYENV_SHELL="fish" PYENV_VERSION="anaconda-2.3.0" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
false
pyenv-virtualenv: activate anaconda-2.3.0
setenv VIRTUAL_ENV "${TMP}/pyenv/versions/anaconda-2.3.0";
setenv CONDA_DEFAULT_ENV "root";
pyenv-virtualenv: prompt changing not work for fish.
EOS
}

@test "activate conda root from command-line argument" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "anaconda-2.3.0"
  create_conda "miniconda-3.9.1"
  stub pyenv-virtualenv-prefix "miniconda-3.9.1 : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1\""
  stub pyenv-prefix "miniconda-3.9.1 : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1\""

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0" run pyenv-sh-activate "miniconda-3.9.1"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
false
pyenv-virtualenv: activate miniconda-3.9.1
export PYENV_VERSION="miniconda-3.9.1";
export PYENV_ACTIVATE_SHELL=1;
export VIRTUAL_ENV="${PYENV_ROOT}/versions/miniconda-3.9.1";
export CONDA_DEFAULT_ENV="root";
pyenv-virtualenv: prompt changing will be removed from future release. configure \`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(miniconda-3.9.1) \${PS1}";
EOS
}

@test "activate conda env from current version" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "anaconda-2.3.0" "foo"
  stub pyenv-version-name "echo anaconda-2.3.0/envs/foo"
  stub pyenv-virtualenv-prefix "anaconda-2.3.0/envs/foo : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""
  stub pyenv-prefix "anaconda-2.3.0/envs/foo : echo \"${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0/envs/foo" run pyenv-sh-activate

  unstub pyenv-version-name
  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
false
pyenv-virtualenv: activate anaconda-2.3.0/envs/foo
export VIRTUAL_ENV="${PYENV_ROOT}/versions/anaconda-2.3.0/envs/foo";
export CONDA_DEFAULT_ENV="foo";
pyenv-virtualenv: prompt changing will be removed from future release. configure \`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(anaconda-2.3.0/envs/foo) \${PS1}";
EOS
}

@test "activate conda env from command-line argument" {
  export PYENV_VIRTUALENV_INIT=1

  create_conda "anaconda-2.3.0" "foo"
  create_conda "miniconda-3.9.1" "bar"
  stub pyenv-virtualenv-prefix "miniconda-3.9.1/envs/bar : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1\""
  stub pyenv-prefix "miniconda-3.9.1/envs/bar : echo \"${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar\""

  PYENV_SHELL="bash" PYENV_VERSION="anaconda-2.3.0/envs/foo" run pyenv-sh-activate "miniconda-3.9.1/envs/bar"

  unstub pyenv-virtualenv-prefix
  unstub pyenv-prefix

  assert_success
  assert_output <<EOS
false
pyenv-virtualenv: activate miniconda-3.9.1/envs/bar
export PYENV_VERSION="miniconda-3.9.1/envs/bar";
export PYENV_ACTIVATE_SHELL=1;
export VIRTUAL_ENV="${PYENV_ROOT}/versions/miniconda-3.9.1/envs/bar";
export CONDA_DEFAULT_ENV="bar";
pyenv-virtualenv: prompt changing will be removed from future release. configure \`export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(miniconda-3.9.1/envs/bar) \${PS1}";
EOS
}
