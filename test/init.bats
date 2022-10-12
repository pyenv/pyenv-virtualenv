#!/usr/bin/env bats

load test_helper

@test "detect parent shell" {
  unset PYENV_SHELL
  SHELL=/bin/false run pyenv-virtualenv-init -
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_pyenv_virtualenv_hook;${PROMPT_COMMAND-}"'
}

@test "detect parent shell from script (sh)" {
  unset PYENV_SHELL
  printf '#!/bin/sh\necho "$(pyenv-virtualenv-init -)"' > "${TMP}/script.sh"
  chmod +x ${TMP}/script.sh
  run ${TMP}/script.sh
  assert_success
  assert_output_contains_not '  PROMPT_COMMAND="_pyenv_virtualenv_hook;${PROMPT_COMMAND-}"'
  rm -f "${TMP}/script.sh"
}

@test "detect parent shell from script (bash)" {
  unset PYENV_SHELL
  printf '#!/bin/bash\necho "$(pyenv-virtualenv-init -)"' > "${TMP}/script.sh"
  chmod +x ${TMP}/script.sh
  run ${TMP}/script.sh
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_pyenv_virtualenv_hook;${PROMPT_COMMAND-}"'
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
  assert_output_contains 'status --is-interactive; and source (pyenv virtualenv-init -|psub)'
}

@test "outputs bash-specific syntax" {
  export PYENV_VIRTUALENV_ROOT="${TMP}/pyenv/plugins/pyenv-virtualenv"
  run pyenv-virtualenv-init - bash
  assert_success
  assert_output <<EOS
export PATH="${TMP}/pyenv/plugins/pyenv-virtualenv/shims:\${PATH}";
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  local ret=\$?
  if [ -n "\${VIRTUAL_ENV-}" ]; then
    eval "\$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "\$(pyenv sh-activate --quiet || true)" || true
  fi
  return \$ret
};
if ! [[ "\${PROMPT_COMMAND-}" =~ _pyenv_virtualenv_hook ]]; then
  PROMPT_COMMAND="_pyenv_virtualenv_hook;\${PROMPT_COMMAND-}"
fi
EOS
}

@test "outputs fish-specific syntax" {
  export PYENV_VIRTUALENV_ROOT="${TMP}/pyenv/plugins/pyenv-virtualenv"
  run pyenv-virtualenv-init - fish
  assert_success
  assert_output <<EOS
while set index (contains -i -- "${TMP}/pyenv/plugins/pyenv-virtualenv/shims" \$PATH)
set -eg PATH[\$index]; end; set -e index
set -gx PATH '${TMP}/pyenv/plugins/pyenv-virtualenv/shims' \$PATH;
set -gx PYENV_VIRTUALENV_INIT 1;
function _pyenv_virtualenv_hook --on-event fish_prompt;
  set -l ret \$status
  if [ -n "\$VIRTUAL_ENV" ]
    pyenv activate --quiet; or pyenv deactivate --quiet; or true
  else
    pyenv activate --quiet; or true
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
export PATH="${TMP}/pyenv/plugins/pyenv-virtualenv/shims:\${PATH}";
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  local ret=\$?
  if [ -n "\${VIRTUAL_ENV-}" ]; then
    eval "\$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "\$(pyenv sh-activate --quiet || true)" || true
  fi
  return \$ret
};
typeset -g -a precmd_functions
if [[ -z \$precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  precmd_functions=(_pyenv_virtualenv_hook \$precmd_functions);
fi
EOS
}
