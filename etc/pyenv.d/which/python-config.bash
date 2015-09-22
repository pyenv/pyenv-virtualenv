# some of libraries require `python-config` in PATH to build native extensions.
# as a workaround, this hook will try to find the executable from the source
# version of the virtualenv.
# https://github.com/yyuu/pyenv/issues/397

if [ ! -x "${PYENV_COMMAND_PATH}" ] && [[ "python"*"-config" == "${PYENV_COMMAND_PATH##*/}" ]]; then
  virtualenv_prefix="$(pyenv-virtualenv-prefix 2>/dev/null || true)"
  if [ -d "${virtualenv_prefix}" ]; then
    virtualenv_command_path="${virtualenv_prefix}/bin/${PYENV_COMMAND_PATH##*/}"
    if [ -x "${virtualenv_command_path}" ]; then
      PYENV_COMMAND_PATH="${virtualenv_command_path}"
    fi
  fi
fi
