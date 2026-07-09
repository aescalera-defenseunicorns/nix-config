{
  lib,
  pkgs,
  ...
}: {
  programs.tmux = {
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
    ];
  };
}
