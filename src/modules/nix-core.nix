{
  pkgs,
  lib,
  ...
}: {
  nix = {
    # enable flakes globally
    settings.experimental-features = ["nix-command" "flakes"];

    package = pkgs.nix;

    # do garbage collection weekly to keep disk usage low
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };

    # Disable auto-optimise-store because of this issue:
    #   https://github.com/NixOS/nix/issues/7273
    # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
    settings = {
      auto-optimise-store = false;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
