#!/usr/bin/env bats

load test_helper

@test "detect parent shell" {
  unset PYENV_SHELL
  SHELL=/bin/false run pyenv-virtualenv-init -
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_pyenv_virtualenv_hook${PROMPT_COMMAND:+;${PROMPT_COMMAND}}"'
}

@test "detect parent shell from script (sh)" {
  unset PYENV_SHELL
  printf '#!/bin/sh\necho "$(pyenv-virtualenv-init -)"' > "${TMP}/script.sh"
  chmod +x ${TMP}/script.sh
  run ${TMP}/script.sh
  assert_success
  assert_output_contains_not '  PROMPT_COMMAND="_pyenv_virtualenv_hook${PROMPT_COMMAND:+;${PROMPT_COMMAND}}"'
  rm -f "${TMP}/script.sh"
}

@test "detect parent shell from script (bash)" {
  unset PYENV_SHELL
  printf '#!/bin/bash\necho "$(pyenv-virtualenv-init -)"' > "${TMP}/script.sh"
  chmod +x ${TMP}/script.sh
  run ${TMP}/script.sh
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_pyenv_virtualenv_hook${PROMPT_COMMAND:+;${PROMPT_COMMAND}}"'
  rm -f "${TMP}/script.sh"
}

@test "fish instructions" {
  run pyenv-virtualenv-init fish
  assert [ "$status" -eq 1 ]
  assert_output_contains 'status --is-interactive; and source (pyenv virtualenv-init -|psub)'
}

@test "other shells instructions" {
    run pyenv-virtualenv-init some_other_sh
    assert [ "$status" -eq 1 ]
    assert_output_contains 'eval "$(pyenv virtualenv-init -)"'
}

@test "outputs bash-specific syntax" {
  export PYENV_VIRTUALENV_ROOT="${TMP}/pyenv/plugins/pyenv-virtualenv"
  run pyenv-virtualenv-init - bash
  assert_success
  assert_output <<EOS
if [[ ":\${PATH:-}:" == *':${TMP}/pyenv/plugins/pyenv-virtualenv/shims:'* ]]; then
  PATH=":\${PATH}:"
  while [[ \$PATH == *':${TMP}/pyenv/plugins/pyenv-virtualenv/shims:'* ]]; do
    PATH=\${PATH//':${TMP}/pyenv/plugins/pyenv-virtualenv/shims:'/:}
  done
  PATH="\${PATH#:}"
  PATH="\${PATH%:}"
fi
export PATH="${TMP}/pyenv/plugins/pyenv-virtualenv/shims:\${PATH}";
export PYENV_VIRTUALENV_INIT=1;
  _pyenv_vh_mtimes() {
    _mtimes="\$(command stat ${_stat_fmt} "\${_PYENV_VH_PATHS[@]}" 2>/dev/null)"
  }
_pyenv_virtualenv_hook() {
  local ret=\$?
  local _mtimes
  if [ "\${PYENV_VERSION-}" = "\${_PYENV_VH_VERSION-}" ] \\
    && [ "\${VIRTUAL_ENV-}" = "\${_PYENV_VH_VENV-}" ]; then
    if [ -n "\${PYENV_VERSION-}" ]; then
      return \$ret
    fi
    if [ "\${PWD}" = "\${_PYENV_VH_PWD-}" ]; then
      _pyenv_vh_mtimes
      if [ "\${_mtimes}" = "\${_PYENV_VH_MTIMES-}" ]; then
        return \$ret
      fi
    fi
  fi
  if [ -n "\${VIRTUAL_ENV-}" ]; then
    eval "\$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "\$(pyenv sh-activate --quiet || true)" || true
  fi
  _PYENV_VH_PWD="\${PWD}"
  _PYENV_VH_VERSION="\${PYENV_VERSION-}"
  _PYENV_VH_VENV="\${VIRTUAL_ENV-}"
  local _pvh_d="\${PWD}" _pvh_found_local=0
  _PYENV_VH_PATHS=()
  while :; do
    if [ -f "\${_pvh_d}/.python-version" ] || [ -L "\${_pvh_d}/.python-version" ]; then
      _PYENV_VH_PATHS+=("\${_pvh_d}/.python-version")
      if [ -f "\${_pvh_d}/.python-version" ]; then
        _pvh_found_local=1
        break
      fi
    else
      _PYENV_VH_PATHS+=("\${_pvh_d}")
    fi
    [ "\${_pvh_d}" = "/" ] && break
    _pvh_d="\${_pvh_d%/*}"
    [ -z "\${_pvh_d}" ] && _pvh_d="/"
  done
  if [ "\${_pvh_found_local}" = "0" ]; then
    _PYENV_VH_PATHS+=("\${PYENV_ROOT:-\${HOME}/.pyenv}/version")
  fi
  _pyenv_vh_mtimes
  _PYENV_VH_MTIMES="\${_mtimes}"
  return \$ret
};
if ! [[ "\${PROMPT_COMMAND-}" =~ _pyenv_virtualenv_hook ]]; then
  PROMPT_COMMAND="_pyenv_virtualenv_hook\${PROMPT_COMMAND:+;\${PROMPT_COMMAND}}"
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
  if test "\$PYENV_VERSION" = "\$_PYENV_VH_VERSION" \\
    -a "\$VIRTUAL_ENV" = "\$_PYENV_VH_VENV"
    if test -n "\$PYENV_VERSION"
      return \$ret
    end
    if test "\$PWD" = "\$_PYENV_VH_PWD"
      set -l mtimes (stat ${_stat_fmt} \$_PYENV_VH_PATHS 2>/dev/null)
      if test (string join " " \$mtimes) = (string join " " \$_PYENV_VH_MTIMES)
        return \$ret
      end
    end
  end
  if [ -n "\$VIRTUAL_ENV" ]
    pyenv activate --quiet; or pyenv deactivate --quiet; or true
  else
    pyenv activate --quiet; or true
  end
  set -g _PYENV_VH_PWD "\$PWD"
  set -g _PYENV_VH_VERSION "\$PYENV_VERSION"
  set -g _PYENV_VH_VENV "\$VIRTUAL_ENV"
  set -l d "\$PWD"
  set -l _pvh_found_local 0
  set -g _PYENV_VH_PATHS
  while true
    if test -f "\$d/.python-version"; or test -L "\$d/.python-version"
      set -g _PYENV_VH_PATHS \$_PYENV_VH_PATHS "\$d/.python-version"
      if test -f "\$d/.python-version"
        set _pvh_found_local 1
        break
      end
    else
      set -g _PYENV_VH_PATHS \$_PYENV_VH_PATHS "\$d"
    end
    test "\$d" = "/"; and break
    set d (string replace -r '/[^/]*\$' '' -- "\$d")
    test -z "\$d"; and set d "/"
  end
  if test "\$_pvh_found_local" = "0"
    set -l _pvh_root "\$PYENV_ROOT"
    test -n "\$_pvh_root"; or set _pvh_root "\$HOME/.pyenv"
    set -g _PYENV_VH_PATHS \$_PYENV_VH_PATHS "\$_pvh_root/version"
  end
  set -g _PYENV_VH_MTIMES (stat ${_stat_fmt} \$_PYENV_VH_PATHS 2>/dev/null)
  return \$ret
end
EOS
}

@test "outputs zsh-specific syntax" {
  export PYENV_VIRTUALENV_ROOT="${TMP}/pyenv/plugins/pyenv-virtualenv"
  run pyenv-virtualenv-init - zsh
  assert_success
  assert_output <<EOS
path=("\${(@)path:#"${TMP}/pyenv/plugins/pyenv-virtualenv/shims"}")
export PATH="${TMP}/pyenv/plugins/pyenv-virtualenv/shims:\${PATH}";
export PYENV_VIRTUALENV_INIT=1;
if zmodload -F zsh/stat b:zstat 2>/dev/null; then
  _pyenv_vh_mtimes() {
    local -a _m
    builtin zstat -A _m +mtime -- \${^_PYENV_VH_PATHS}(N) 2>/dev/null
    _mtimes="\${(j: :)_m}"
  }
else
  _pyenv_vh_mtimes() {
    _mtimes="\$(command stat ${_stat_fmt} "\${_PYENV_VH_PATHS[@]}" 2>/dev/null)"
  }
fi
_pyenv_virtualenv_hook() {
  local ret=\$?
  local _mtimes
  if [ "\${PYENV_VERSION-}" = "\${_PYENV_VH_VERSION-}" ] \\
    && [ "\${VIRTUAL_ENV-}" = "\${_PYENV_VH_VENV-}" ]; then
    if [ -n "\${PYENV_VERSION-}" ]; then
      return \$ret
    fi
    if [ "\${PWD}" = "\${_PYENV_VH_PWD-}" ]; then
      _pyenv_vh_mtimes
      if [ "\${_mtimes}" = "\${_PYENV_VH_MTIMES-}" ]; then
        return \$ret
      fi
    fi
  fi
  if [ -n "\${VIRTUAL_ENV-}" ]; then
    eval "\$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "\$(pyenv sh-activate --quiet || true)" || true
  fi
  _PYENV_VH_PWD="\${PWD}"
  _PYENV_VH_VERSION="\${PYENV_VERSION-}"
  _PYENV_VH_VENV="\${VIRTUAL_ENV-}"
  local _pvh_d="\${PWD}" _pvh_found_local=0
  _PYENV_VH_PATHS=()
  while :; do
    if [ -f "\${_pvh_d}/.python-version" ] || [ -L "\${_pvh_d}/.python-version" ]; then
      _PYENV_VH_PATHS+=("\${_pvh_d}/.python-version")
      if [ -f "\${_pvh_d}/.python-version" ]; then
        _pvh_found_local=1
        break
      fi
    else
      _PYENV_VH_PATHS+=("\${_pvh_d}")
    fi
    [ "\${_pvh_d}" = "/" ] && break
    _pvh_d="\${_pvh_d%/*}"
    [ -z "\${_pvh_d}" ] && _pvh_d="/"
  done
  if [ "\${_pvh_found_local}" = "0" ]; then
    _PYENV_VH_PATHS+=("\${PYENV_ROOT:-\${HOME}/.pyenv}/version")
  fi
  _pyenv_vh_mtimes
  _PYENV_VH_MTIMES="\${_mtimes}"
  return \$ret
};
typeset -g -a precmd_functions
if [[ -z \$precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  precmd_functions=(_pyenv_virtualenv_hook \$precmd_functions);
fi
EOS
}

@test "outputs other shells syntax" {
  export PYENV_VIRTUALENV_ROOT="${TMP}/pyenv/plugins/pyenv-virtualenv"
  run pyenv-virtualenv-init - some_other_sh
  assert_success
  assert_output <<EOS
export PATH="${TMP}/pyenv/plugins/pyenv-virtualenv/shims:\${PATH}";
export PYENV_VIRTUALENV_INIT=1;
EOS
}

@test "removes existing shims from PATH without spawning bash (bash)" {
  export PYENV_VIRTUALENV_ROOT="${TMP}/pyenv/plugins/pyenv-virtualenv"
  local shims="${PYENV_VIRTUALENV_ROOT}/shims"
  local old_path="$PATH"
  export PATH="${shims}:${TMP}/first:${shims}:${shims}:${shims}-extra:${old_path}:${shims}"
  run bash -eu <<EOS
init_code="\$(pyenv-virtualenv-init - bash)"
bash() {
  echo "unexpected bash subprocess" >&2
  return 1
}
eval "\$init_code"
printf '%s\n' "\$PATH"
EOS
  assert_success
  assert_output "${shims}:${TMP}/first:${shims}-extra:${old_path}"
}

@test "removes existing shims from PATH with special characters (bash)" {
  export PYENV_VIRTUALENV_ROOT="${TMP}/root's \"\$x\" *?[dir]"
  local shims="${PYENV_VIRTUALENV_ROOT}/shims"
  local old_path="$PATH"
  export PATH="${TMP}/first:${shims}:${shims}-extra:${old_path}"
  run bash -eu <<'EOS'
init_code="$(pyenv-virtualenv-init - bash)"
unset PYENV_VIRTUALENV_ROOT
eval "$init_code"
printf '%s\n' "$PATH"
EOS
  assert_success
  assert_output "${shims}:${TMP}/first:${shims}-extra:${old_path}"
}

@test "removes existing shims from PATH (zsh)" {
  command -v zsh >/dev/null || skip "-- zsh not installed"
  export PYENV_VIRTUALENV_ROOT="${TMP}/pyenv plugins/pyenv-virtualenv"
  local shims="${PYENV_VIRTUALENV_ROOT}/shims"
  local old_path="$PATH"
  export PATH="${TMP}/first:${shims}:${shims}:${shims}-extra:${old_path}"
  run zsh -df - <<'EOS'
eval "$(pyenv-virtualenv-init - zsh)"
printf '%s\n' "$PATH"
EOS
  assert_success
  assert_output "${shims}:${TMP}/first:${shims}-extra:${old_path}"
}

@test "removes existing shims from PATH with special characters (zsh)" {
  command -v zsh >/dev/null || skip "-- zsh not installed"
  export PYENV_VIRTUALENV_ROOT="${TMP}/root's \"\$x\" *?[dir]"
  local shims="${PYENV_VIRTUALENV_ROOT}/shims"
  local old_path="$PATH"
  export PATH="${TMP}/first:${shims}:${shims}-extra:${old_path}"
  run zsh -df - <<'EOS'
init_code="$(pyenv-virtualenv-init - zsh)"
unset PYENV_VIRTUALENV_ROOT
eval "$init_code"
printf '%s\n' "$PATH"
EOS
  assert_success
  assert_output "${shims}:${TMP}/first:${shims}-extra:${old_path}"
}
