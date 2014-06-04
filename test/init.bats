#!/usr/bin/env bats

load test_helper

@test "detect parent shell" {
  root="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  SHELL=/bin/false run pyenv-virtualenv-init -
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_pyenv_virtualenv_hook;$PROMPT_COMMAND";'
}

@test "sh-compatible instructions" {
  run pyenv-virtualenv-init bash
  assert [ "$status" -eq 1 ]
  assert_output_contains 'eval "$(pyenv virtualenv-init -)"'

  run pyenv-virtualenv-init zsh
  assert [ "$status" -eq 1 ]
  assert_output_contains 'eval "$(pyenv virtualenv-init -)"'
}

@test "fish instructions" {
  run pyenv-virtualenv-init fish
  assert [ "$status" -eq 1 ]
  assert_output_contains 'status --is-interactive; and . (pyenv virtualenv-init -|psub)'
}

@test "outputs bash-specific syntax" {
  run pyenv-virtualenv-init - bash
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_pyenv_virtualenv_hook;$PROMPT_COMMAND";'
}

@test "outputs fish-specific syntax" {
  run pyenv-virtualenv-init - fish
  assert_success
  assert_output_contains 'function _pyenv_virtualenv_hook --on-event fish_prompt;'
}

@test "outputs zsh-specific syntax" {
  run pyenv-virtualenv-init - zsh
  assert_success
  assert_output_contains '  precmd_functions+=_pyenv_virtualenv_hook;'
}
