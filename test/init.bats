#!/usr/bin/env bats

load test_helper

@test "detect parent shell" {
  unset PYENV_SHELL
  SHELL=/bin/false run pyenv-virtualenv-init -
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_pyenv_virtualenv_hook;$PROMPT_COMMAND";'
}

@test "detect parent shell from script (sh)" {
  unset PYENV_SHELL
  printf '#!/bin/sh\necho "$(pyenv-virtualenv-init -)"' > "${TMP}/script.sh"
  chmod +x ${TMP}/script.sh
  run ${TMP}/script.sh
  assert_success
  assert_output_contains_not '  PROMPT_COMMAND="_pyenv_virtualenv_hook;$PROMPT_COMMAND";'
  rm -f "${TMP}/script.sh"
}

@test "detect parent shell from script (bash)" {
  unset PYENV_SHELL
  printf '#!/bin/bash\necho "$(pyenv-virtualenv-init -)"' > "${TMP}/script.sh"
  chmod +x ${TMP}/script.sh
  run ${TMP}/script.sh
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_pyenv_virtualenv_hook;$PROMPT_COMMAND";'
  rm -f "${TMP}/script.sh"
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
  export PYENV_VIRTUALENV_ROOT="${TMP}/pyenv/plugins/pyenv-virtualenv"
  run pyenv-virtualenv-init - bash
  assert_success
  assert_output <<EOS
export PATH="${TMP}/pyenv/plugins/pyenv-virtualenv/shims:${PATH}";
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  local ret=\$?
  if [ -n "\$PYENV_ACTIVATE" ]; then
    if [ "\$(pyenv version-name 2>/dev/null || true)" = "system" ]; then
      eval "\$(pyenv sh-deactivate --no-error --verbose)"
      unset PYENV_DEACTIVATE
      return \$ret
    fi
    if [ "\$PYENV_ACTIVATE" != "\$(pyenv prefix 2>/dev/null || true)" ]; then
      if eval "\$(pyenv sh-deactivate --no-error --verbose)"; then
        unset PYENV_DEACTIVATE
        eval "\$(pyenv sh-activate --no-error --verbose)" || unset PYENV_DEACTIVATE
      else
        eval "\$(pyenv sh-activate --no-error --verbose)"
      fi
    fi
  else
    if [ -z "\$VIRTUAL_ENV" ] && [ "\$PYENV_DEACTIVATE" != "\$(pyenv prefix 2>/dev/null || true)" ]; then
      eval "\$(pyenv sh-activate --no-error --verbose)" || true
    fi
  fi
  return \$ret
};
if ! [[ "\$PROMPT_COMMAND" =~ _pyenv_virtualenv_hook ]]; then
  PROMPT_COMMAND="_pyenv_virtualenv_hook;\$PROMPT_COMMAND";
fi
EOS
}

@test "outputs fish-specific syntax" {
  export PYENV_VIRTUALENV_ROOT="${TMP}/pyenv/plugins/pyenv-virtualenv"
  run pyenv-virtualenv-init - fish
  assert_success
  assert_output <<EOS
setenv PATH '${TMP}/pyenv/plugins/pyenv-virtualenv/shims' \$PATH;
setenv PYENV_VIRTUALENV_INIT 1;
function _pyenv_virtualenv_hook --on-event fish_prompt;
  set -l PYENV_PREFIX (pyenv prefix 2>/dev/null; or true)
  set -l ret \$status
  if [ -n "\$PYENV_ACTIVATE" ]
    if [ (pyenv version-name 2>/dev/null; or true) = "system" ]
      pyenv deactivate --no-error --verbose
      set -e PYENV_DEACTIVATE
      return \$ret
    end
    if [ "\$PYENV_ACTIVATE" != "\$PYENV_PREFIX" ]
      if pyenv deactivate --no-error --verbose
        set -e PYENV_DEACTIVATE
        pyenv activate --no-error --verbose; or set -e PYENV_DEACTIVATE
      else
        pyenv activate --no-error --verbose
      end
    end
  else
    if [ -z "\$VIRTUAL_ENV" ]; and [ "\$PYENV_DEACTIVATE" != "\$PYENV_PREFIX" ]
      pyenv activate --no-error --verbose; or true
    end
  end
  return \$ret
end
EOS
}

@test "outputs zsh-specific syntax" {
  export PYENV_VIRTUALENV_ROOT="${TMP}/pyenv/plugins/pyenv-virtualenv"
  run pyenv-virtualenv-init - zsh
  assert_success
  assert_output <<EOS
export PATH="${TMP}/pyenv/plugins/pyenv-virtualenv/shims:${PATH}";
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  local ret=\$?
  if [ -n "\$PYENV_ACTIVATE" ]; then
    if [ "\$(pyenv version-name 2>/dev/null || true)" = "system" ]; then
      eval "\$(pyenv sh-deactivate --no-error --verbose)"
      unset PYENV_DEACTIVATE
      return \$ret
    fi
    if [ "\$PYENV_ACTIVATE" != "\$(pyenv prefix 2>/dev/null || true)" ]; then
      if eval "\$(pyenv sh-deactivate --no-error --verbose)"; then
        unset PYENV_DEACTIVATE
        eval "\$(pyenv sh-activate --no-error --verbose)" || unset PYENV_DEACTIVATE
      else
        eval "\$(pyenv sh-activate --no-error --verbose)"
      fi
    fi
  else
    if [ -z "\$VIRTUAL_ENV" ] && [ "\$PYENV_DEACTIVATE" != "\$(pyenv prefix 2>/dev/null || true)" ]; then
      eval "\$(pyenv sh-activate --no-error --verbose)" || true
    fi
  fi
  return \$ret
};
typeset -g -a precmd_functions
if [[ -z \$precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  precmd_functions=(_pyenv_virtualenv_hook \$precmd_functions);
fi
EOS
}
