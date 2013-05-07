#!/bin/sh

set -e

if [ -z "${PREFIX}" ]; then
  PREFIX="/usr/local"
fi

BIN_PATH="${PREFIX}/bin"
LIBEXEC_PATH="${PREFIX}/libexec/pyenv-virtualenv"

mkdir -p "${BIN_PATH}"
mkdir -p "${LIBEXEC_PATH}"

for file in bin/*; do
  cp "${file}" "${BIN_PATH}"
done

for file in libexec/pyenv-virtualenv/*.py; do
  cp "${file}" "${LIBEXEC_PATH}"
done

echo "Installed pyenv-virtualenv at ${PREFIX}"
