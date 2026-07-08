HOSTNAME := $(shell hostname)
SHELL := /bin/bash

.DEFAULT_GOAL := darwin

# normal targets
.PHONY: darwin
darwin: darwin/build darwin/apply darwin/activate

.PHONY: darwin/build
darwin/build:
	nix build './src/.#darwinConfigurations.$(HOSTNAME).system' --extra-experimental-features 'nix-command flakes'

.PHONY: darwin/apply
darwin/apply:
	sudo ./result/sw/bin/darwin-rebuild switch --flake './src/.#$(HOSTNAME)'

.PHONY: darwin/activate
darwin/activate:
	sudo /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# test target
.PHONY: test
test: darwin/build

.PHONY: test/debug
test/debug: debug/build

# debug targets
.PHONY: debug
debug: debug/build debug/apply darwin/activate

.PHONY: debug/build
debug/build:
	nix build './src/.#darwinConfigurations.$(HOSTNAME).system' --show-trace --verbose --extra-experimental-features 'nix-command flakes'

.PHONY: debug/apply
debug/apply:
	sudo ./result/sw/bin/darwin-rebuild switch --flake './src/.#$(HOSTNAME)' --show-trace --verbose

# update all flake inputs (updates nixpkgs, home-manager, etc)
# run this, then the darwin target to update packages
.PHONY: update
update:
	nix flake update --flake './src'

# List all generations of the system profile
.PHONY: history
history:
	nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
.PHONY: repl
repl:
	nix repl -f flake:nixpkgs

# remove all generations older than 7 days
.PHONY: clean
clean:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

# Garbage collect all unused nix store entries
.PHONY: gc
gc:
	sudo nix-collect-garbage --delete-older-than 7d # garbage collect all unused nix store entries(system-wide)
	nix-collect-garbage --delete-older-than 7d # garbage collect all unused nix store entries(for the user - home-manager)
	# https://github.com/NixOS/nix/issues/8508

# format the code
.PHONY: alejandra
alejandra:
	alejandra ./src/*

.PHONY: fmt
fmt: alejandra

# show all the auto gc roots in the nix store
.PHONY: gcroot
gcroot:
	ls -al /nix/var/nix/gcroots/auto/
