resolve_link() {
  $(type -p greadlink readlink | head -1) "$1"
}

uninstall_related_virtual_env() {
  if [ -n "${DEFINITION}" ]; then
    if [[ "${DEFINITION}" != "${DEFINITION%/envs/*}" ]]; then
      # Uninstall virtualenv by long name
      pyenv-virtualenv-delete ${FORCE+-f} "${DEFINITION}"
    else
      VERSION_NAME="${VERSION_NAME:-${DEFINITION##*/}}"
      PREFIX="${PREFIX:-${PYENV_ROOT}/versions/${VERSION_NAME}}"
      if [ -L "${PREFIX}" ]; then
        REAL_PREFIX="$(resolve_link "${PREFIX}" 2>/dev/null || true)"
        REAL_DEFINITION="${REAL_PREFIX#${PYENV_ROOT}/versions/}"
        if [[ "${REAL_DEFINITION}" != "${REAL_DEFINITION%/envs/*}" ]]; then
          # Uninstall virtualenv by short name
          pyenv-virtualenv-delete ${FORCE+-f} "${REAL_DEFINITION}"
        fi
      else
        # Uninstall all virtualenvs inside `envs` directory too
        shopt -s nullglob
        for virtualenv in "${PREFIX}/envs/"*; do
          pyenv-virtualenv-delete ${FORCE+-f} "${DEFINITION}/envs/${virtualenv##*/}"
        done
        shopt -u nullglob
      fi
    fi
  fi
}

before_uninstall "uninstall_related_virtual_env"
