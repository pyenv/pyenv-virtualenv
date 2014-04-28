#!/bin/sh
# Usage: PREFIX=/usr/local ./install.sh
#
# Installs pyenv-virtualenv under $PREFIX.

set -e

cd "$(dirname "$0")"

if [ -z "${PREFIX}" ]; then
  PREFIX="/usr/local"
fi

BIN_PATH="${PREFIX}/bin"
ETC_PATH="${PREFIX}/etc/pyenv.d"

mkdir -p "$BIN_PATH"
mkdir -p "$ETC_PATH"

install -p bin/* "$BIN_PATH"
cp -RPp etc/pyenv.d/* "$ETC_PATH"
