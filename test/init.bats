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
  virtualenv="\$(pyenv virtualenv-name || true)"
  prefix="\$(pyenv prefix "\$virtualenv" 2>/dev/null || true)"

  if [ -n "\$PYENV_ACTIVATE" ]; then
    if [ -n "\$virtualenv" ]; then
      if [ "\$PYENV_ACTIVATE" != "\$prefix" ]; then
        if pyenv deactivate --no-error --verbose; then
          pyenv activate --no-error --verbose || unset PYENV_DEACTIVATE
        else
          pyenv activate --no-error --verbose
        fi
      fi
    else
      pyenv deactivate --no-error --verbose
      unset PYENV_DEACTIVATE
      return 0
    fi
  else
    if [ -z "\$VIRTUAL_ENV" ]; then
      if [ -n "\$virtualenv" ] && [ "\$PYENV_DEACTIVATE" != "\$prefix" ]; then
        pyenv activate --no-error --verbose || true
      fi
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
  set -l virtualenv (pyenv virtualenv-name; or true)
  set -l prefix (pyenv prefix "\$virtualenv" 2>/dev/null; or true)

  if [ -n "\$PYENV_ACTIVATE" ]
    if [ -n "\$virtualenv" ]
      if [ "\$PYENV_ACTIVATE" != "\$prefix" ]
        if pyenv deactivate --no-error --verbose
          pyenv activate --no-error --verbose; or set -e PYENV_DEACTIVATE
        else
          pyenv activate --no-error --verbose
        end
      end
    else
      pyenv deactivate --no-error --verbose
      set -e PYENV_DEACTIVATE
      return 0
    end
  else
    if [ -z "\$VIRTUAL_ENV" ]
      if [ -n "\$virtualenv" ]; and [ "\$PYENV_DEACTIVATE" != "\$prefix" ]
        pyenv activate --no-error --verbose; or true
      end
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
  virtualenv="\$(pyenv virtualenv-name || true)"
  prefix="\$(pyenv prefix "\$virtualenv" 2>/dev/null || true)"

  if [ -n "\$PYENV_ACTIVATE" ]; then
    if [ -n "\$virtualenv" ]; then
      if [ "\$PYENV_ACTIVATE" != "\$prefix" ]; then
        if pyenv deactivate --no-error --verbose; then
          pyenv activate --no-error --verbose || unset PYENV_DEACTIVATE
        else
          pyenv activate --no-error --verbose
        fi
      fi
    else
      pyenv deactivate --no-error --verbose
      unset PYENV_DEACTIVATE
      return 0
    fi
  else
    if [ -z "\$VIRTUAL_ENV" ]; then
      if [ -n "\$virtualenv" ] && [ "\$PYENV_DEACTIVATE" != "\$prefix" ]; then
        pyenv activate --no-error --verbose || true
      fi
    fi
  fi
};
typeset -a precmd_functions
if [[ -z \$precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  precmd_functions+=_pyenv_virtualenv_hook;
fi
EOS
}
