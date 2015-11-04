virtualenv_list_executable_names() {
  local file
  shopt -s nullglob
  for file in "$PYENV_ROOT"/versions/*/envs/*/bin/*; do
    echo "${file##*/}"
  done
  shopt -u nullglob
}
if declare -f make_shims 1>/dev/null 2>&1; then
  make_shims $(virtualenv_list_executable_names | sort -u)
fi
