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

## GitHub Actions

Pull requests and pushes to `main` run Alejandra (`--check`) and `statix check`
in parallel. Both must pass before `nix flake check` builds the complete
`aarch64-darwin` configuration on a macOS runner, without activating it.
The tools come from the flake's locked `nixpkgs-darwin` input.

Every day at 10:23 UTC, **Update flake inputs** runs `nix flake update`, repeats
those checks, and rejects any `warning:` in lint or build output. Successful
lockfile changes are opened as a PR and immediately squash-merged into `main`.
An unchanged lockfile produces no PR. Either workflow can also run manually
from the Actions tab; updates only run from `main`.

In **Settings → Actions → General → Workflow permissions**, enable
**Allow GitHub Actions to create and approve pull requests**. The updater uses
the built-in `GITHUB_TOKEN`; no PAT is needed. Validation runs within the update
workflow because PRs created with that token do not automatically run CI.
Merging respects repository branch protections; required reviews or additional
required checks can block it.

## TODO

- user apps config (firefox/chrome extensions/themes, windsurf extensions, etc)
- hydra/build cache
- automated testing (vm?)

## References

- [nix-darwin](https://github.com/nix-darwin/nix-darwin)
- [macos-defaults](https://github.com/yannbertrand/macos-defaults)
- [ryan4yin/nix-darwin-kickstarter](https://github.com/ryan4yin/nix-darwin-kickstarter)
- [ryan4yin/nix-config/modules/darwin](https://github.com/ryan4yin/nix-config/tree/main/modules/darwin)
