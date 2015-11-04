resolve_link() {
  $(type -p greadlink readlink | head -1) "$1"
}

if [ -n "${DEFINITION}" ]; then
  if [[ "${DEFINITION}" != "${DEFINITION%/envs/*}" ]]; then
    exec pyenv-virtualenv-delete ${FORCE+-f} "${DEFINITION}"
    exit 128
  else
    VERSION_NAME="${VERSION_NAME:-${DEFINITION##*/}}"
    PREFIX="${PREFIX:-${PYENV_ROOT}/versions/${VERSION_NAME}}"
    if [ -L "${PREFIX}" ]; then
      REAL_PREFIX="$(resolve_link "${PREFIX}" 2>/dev/null || true)"
      REAL_DEFINITION="${REAL_PREFIX#${PYENV_ROOT}/versions/}"
      if [[ "${REAL_DEFINITION}" != "${REAL_DEFINITION%/envs/*}" ]]; then
        exec pyenv-virtualenv-delete ${FORCE+-f} "${REAL_DEFINITION}"
        exit 128
      fi
    fi
  fi
fi
