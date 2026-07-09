{pkgs, ...}: {
  # don't install packages with this.
  # home.packages = with pkgs; [];

  programs = {
    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      enableZshIntegration = true;
    };
  };

  catppuccin.enable = true;
  catppuccin.autoEnable = true;
}
