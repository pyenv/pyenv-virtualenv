.PHONY: all test

all: test

bats:
	git clone https://github.com/bats-core/bats-core bats

test: bats
	bats/bin/bats --tap test