HOSTNAME := $(shell hostname)
SHELL := /bin/bash

.PHONY: darwin debug darwin/build darwin/apply darwin/activate debug/build debug/apply

# normal targets
darwin: darwin/build darwin/apply darwin/activate

darwin/build:
	nix build './src/.#darwinConfigurations.$(HOSTNAME).system' --extra-experimental-features 'nix-command flakes'

darwin/apply:
	sudo ./result/sw/bin/darwin-rebuild switch --flake './src/.#$(HOSTNAME)'

darwin/activate:
	sudo /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u


# debug targets
debug: debug/build debug/apply darwin/activate

debug/build:
	nix build './src/.#darwinConfigurations.$(HOSTNAME).system' --show-trace --verbose --extra-experimental-features 'nix-command flakes'

debug/apply:
	sudo ./result/sw/bin/darwin-rebuild switch --flake './src/.#$(HOSTNAME)' --show-trace --verbose

# update all flake inputs (updates nixpkgs, home-manager, etc)
# run this, then the darwin target to update packages
update:
	nix flake update --flake './src'

# List all generations of the system profile
history:
	nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
repl:
	nix repl -f flake:nixpkgs

# remove all generations older than 7 days
clean:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

# Garbage collect all unused nix store entries
gc:
	sudo nix-collect-garbage --delete-older-than 7d # garbage collect all unused nix store entries(system-wide)
	nix-collect-garbage --delete-older-than 7d # garbage collect all unused nix store entries(for the user - home-manager)
	# https://github.com/NixOS/nix/issues/8508

# format the code
alejandra:
	alejandra ./src/*

fmt: alejandra

# show all the auto gc roots in the nix store
gcroot:
	ls -al /nix/var/nix/gcroots/auto/
