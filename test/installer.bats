#!/usr/bin/env bats

load test_helper

@test "installs pyenv-virtualenv into PREFIX" {
  cd "$TMP"
  PREFIX="${PWD}/usr" run "${BATS_TEST_DIRNAME}/../install.sh"
  assert_success ""

  cd usr

  assert [ -x bin/pyenv-activate ]
  assert [ -x bin/pyenv-deactivate ]
  assert [ -x bin/pyenv-sh-activate ]
  assert [ -x bin/pyenv-sh-deactivate ]
  assert [ -x bin/pyenv-virtualenv ]
  assert [ -x bin/pyenv-virtualenv-init ]
  assert [ -x bin/pyenv-virtualenv-prefix ]
  assert [ -x bin/pyenv-virtualenvs ]
}

@test "overwrites old installation" {
  cd "$TMP"
  mkdir -p bin
  touch bin/pyenv-virtualenv

  PREFIX="$PWD" run "${BATS_TEST_DIRNAME}/../install.sh"
  assert_success ""

  assert [ -x bin/pyenv-virtualenv ]
  run grep "virtualenv" bin/pyenv-virtualenv
  assert_success
}

@test "unrelated files are untouched" {
  cd "$TMP"
  mkdir -p bin share/bananas
  chmod g-w bin
  touch bin/bananas

  PREFIX="$PWD" run "${BATS_TEST_DIRNAME}/../install.sh"
  assert_success ""

  assert [ -e bin/bananas ]

  run ls -ld bin
  assert_equal "r-x" "${output:4:3}"
}
