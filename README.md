# My nix-darwin config

This is an opinionated nix-darwin + home-manager + flakes configuration for my work use as a platform/software engineer.

## Why nix?

- single ecosystem for the entirety of system and user configuration
- declarative and functional
- powerful enough to capture any detail, but still only requires minimal configuration in most cases
- turing complete, easy to make higher-level abstractions
- atomic rollbacks
- easily version controlled

## Usage

Install brew, then install nix, then fork and clone this repo, then build and apply the configuration

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # install homebrew
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) # install nix
git clone https://github.com/aescalera-defenseunicorns/nix-config.git && cd nix-config # clone and cd into the repo
cp ./src/config.default.nix ./src/config.nix # copy the default config
nvim ./src/config.nix # edit the config with your information
make # build and apply the config
```

Updating is as simple as running `make` again.

### Debugging

use the `debug` target of the makefile to help diagnose build/apply issues

## TODO

- user apps config (firefox/chrome extensions/themes, windsurf extensions, etc)
- hydra/build cache
- automated testing (vm?)

## References

- [nix-darwin](https://github.com/nix-darwin/nix-darwin)
- [macos-defaults](https://github.com/yannbertrand/macos-defaults)
- [ryan4yin/nix-darwin-kickstarter](https://github.com/ryan4yin/nix-darwin-kickstarter)
- [ryan4yin/nix-config/modules/darwin](https://github.com/ryan4yin/nix-config/tree/main/modules/darwin)
