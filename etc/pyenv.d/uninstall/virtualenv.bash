VERSION_NAME="${DEFINITION##*/}"
PREFIX="${PYENV_ROOT}/versions/${VERSION_NAME}"

if ! pyenv-virtualenv-prefix "${VERSION_NAME}" 1>/dev/null 2>&1; then
  OLDIFS="$IFS"
  IFS=$'\n' virtualenvs=($(pyenv-virtualenvs --bare))
  IFS="$OLDIFS"

  declare -a dependencies
  for venv in "${virtualenvs[@]}"; do
    venv_prefix="$(pyenv-virtualenv-prefix "${venv}" 2>/dev/null || true)"
    if [ -d "${venv_prefix}" ] && [ "${PREFIX}" = "${venv_prefix}" ]; then
      dependencies[${#dependencies[*]}]="${venv}"
    fi
  done

  if [ -z "$FORCE" ] && [ -n "$dependencies" ]; then
    echo "pyenv: ${#dependencies[@]} virtualenv(s) is depending on $PREFIX." >&2
    read -p "continue with uninstallation? (y/N) "
    case "$REPLY" in
    y* | Y* ) ;;
    * ) exit 1 ;;
    esac
  fi
fi
