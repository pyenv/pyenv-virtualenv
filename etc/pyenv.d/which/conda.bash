# newer versions of conda share programs from the real prefix
# this hook tries to find the executable there

if [ ! -x "${PYENV_COMMAND_PATH}" ] && [[ "${PYENV_COMMAND_PATH##*/}" == "conda" ]]; then
  if [ -d "${PYENV_ROOT}/versions/${version}/conda-meta" ]; then
    conda_command_path="$(pyenv-virtualenv-prefix "$version")"/bin/"${PYENV_COMMAND_PATH##*/}"
    if [ -x "${conda_command_path}" ]; then
      PYENV_COMMAND_PATH="${conda_command_path}"
    fi
  fi
fi
