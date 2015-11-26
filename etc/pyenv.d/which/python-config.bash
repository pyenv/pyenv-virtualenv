# some of libraries require `python-config` in PATH to build native extensions.
# as a workaround, this hook will try to find the executable from the source
# version of the virtualenv.
# https://github.com/yyuu/pyenv/issues/397

if [ ! -x "${PYENV_COMMAND_PATH}" ] && [[ "${PYENV_COMMAND_PATH##*/}" == "python"*"-config" ]]; then
  OLDIFS="${IFS}"
  IFS=:
  version="$(pyenv-version-name)"
  IFS="${OLDIFS}"
  if [ -f "${PYENV_ROOT}/versions/${version}/bin/activate" ]; then
    if [ -f "${PYENV_ROOT}/versions/${version}/bin/conda" ]; then
      : # do nothing for conda's environments
    else
      if [ -f "${PYENV_ROOT}/versions/${version}/bin/pyvenv.cfg" ]; then
        # pyvenv
        virtualenv_binpath="$(cut -b 1-1024 "${PYENV_ROOT}/versions/${version}/pyvenv.cfg" | sed -n '/^ *home *= */s///p' || true)"
        virtualenv_prefix="${virtualenv_binpath%/bin}"
      else
        # virtualenv
        shopt -s nullglob
        virtualenv_prefix="$(cat "${PYENV_ROOT}/versions/${version}/lib/"*"/orig-prefix.txt" </dev/null 2>&1 || true)"
        shopt -u nullglob
      fi
      virtualenv_command_path="${virtualenv_prefix}/bin/${PYENV_COMMAND_PATH##*/}"
      if [ -x "${virtualenv_command_path}" ]; then
        PYENV_COMMAND_PATH="${virtualenv_command_path}"
      fi
    fi
  fi
fi
