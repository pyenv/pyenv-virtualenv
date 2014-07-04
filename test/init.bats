#!/usr/bin/env bats

load test_helper

@test "detect parent shell" {
  root="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  SHELL=/bin/false run pyenv-virtualenv-init -
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_pyenv_virtualenv_hook;$PROMPT_COMMAND";'
}

@test "sh-compatible instructions" {
  run pyenv-virtualenv-init bash
  assert [ "$status" -eq 1 ]
  assert_output_contains 'eval "$(pyenv virtualenv-init -)"'

  run pyenv-virtualenv-init zsh
  assert [ "$status" -eq 1 ]
  assert_output_contains 'eval "$(pyenv virtualenv-init -)"'
}

@test "fish instructions" {
  run pyenv-virtualenv-init fish
  assert [ "$status" -eq 1 ]
  assert_output_contains 'status --is-interactive; and . (pyenv virtualenv-init -|psub)'
}

@test "outputs bash-specific syntax" {
  run pyenv-virtualenv-init - bash
  assert_success
  assert_output <<EOS
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  if [ -n "\$VIRTUAL_ENV" ]; then
    if [ "x\`pyenv version-name\`" = "xsystem" ]; then
      pyenv deactivate --no-error --verbose
      return 0
    fi
    if [ "x\$VIRTUAL_ENV" != "x\`pyenv prefix\`" ]; then
      pyenv deactivate --no-error --verbose
      pyenv activate --no-error --verbose
    fi
  else
    if [ "x\$PYENV_DEACTIVATE" != "x\`pyenv prefix\`" ]; then
      pyenv activate --no-error --verbose
    fi
  fi
};
if ! [[ "\$PROMPT_COMMAND" =~ _pyenv_virtualenv_hook ]]; then
  PROMPT_COMMAND="_pyenv_virtualenv_hook;\$PROMPT_COMMAND";
fi
EOS
}

@test "outputs fish-specific syntax" {
  run pyenv-virtualenv-init - fish
  assert_success
  assert_output <<EOS
setenv PYENV_VIRTUALENV_INIT 1;
function _pyenv_virtualenv_hook --on-event fish_prompt;
  if [ -n "\$VIRTUAL_ENV" ]
    if [ (pyenv version-name) = "system" ]
      eval (pyenv sh-deactivate --no-error --verbose)
      return 0
    end
    if [ "\$VIRTUAL_ENV" != (pyenv prefix) ]
      eval (pyenv sh-deactivate --no-error --verbose)
      eval (pyenv sh-activate --no-error --verbose)
    end
  else
    if [ "\$PYENV_DEACTIVATE" != (pyenv prefix) ]
      eval (pyenv sh-activate --no-error --verbose)
    end
  end
end
EOS
}

@test "outputs zsh-specific syntax" {
  run pyenv-virtualenv-init - zsh
  assert_success
  assert_output <<EOS
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  if [ -n "\$VIRTUAL_ENV" ]; then
    if [ "x\`pyenv version-name\`" = "xsystem" ]; then
      pyenv deactivate --no-error --verbose
      return 0
    fi
    if [ "x\$VIRTUAL_ENV" != "x\`pyenv prefix\`" ]; then
      pyenv deactivate --no-error --verbose
      pyenv activate --no-error --verbose
    fi
  else
    if [ "x\$PYENV_DEACTIVATE" != "x\`pyenv prefix\`" ]; then
      pyenv activate --no-error --verbose
    fi
  fi
};
typeset -a precmd_functions
if [[ -z \$precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  precmd_functions+=_pyenv_virtualenv_hook;
fi
EOS
}
