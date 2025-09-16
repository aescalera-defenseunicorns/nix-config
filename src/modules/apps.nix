{pkgs, ...}: {
  # Install packages from nix's official package repository.
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    # k8s
    kubectl
    k9s
    docker-buildx
    docker-compose

    qemu

    # langs
    go
    golangci-lint
    #gci
    gofumpt
    gosec
    govulncheck
    alejandra # better nix fmt
    uv # better python virtual envs

    # new utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    neovim
    bat
    eza
    btop
    caddy
    tldr
    zellij

    # security

    syft
    grype
    semgrep

    # standard utils
    file
    which
    tree
    gnused
    gnutar
    gnumake
    gawk
    zstd
    gnupg
    pinentry-curses
    wget
    curl
    tmux
    git

    # archives
    zip
    xz
    unzip
    p7zip

    # productivity
    glow # markdown previewer in terminal

    # dev
    chatgpt
    claude-code

    # infra
    terraform
    packer
    ansible
  ];
  environment.variables.EDITOR = "nvim";

  # Prefer to install from nixpkgs, but some apps are not available there, or are broken.
  # homebrew must be installed manually first.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      # Xcode = 497799835;
    };

    taps = [
      "defenseunicorns/tap"
    ];

    # prefer to use environment.systemPackages over this
    # `brew install`
    brews = [
      "docker"
      "podman"
      "colima"
      "k3d"
      "helm"

      "pinentry-mac"

      "zarf"
      "uds"

      "gci"
    ];

    # `brew install --cask`
    casks = [
      "firefox"
      "google-chrome"

      "hammerspoon" # gui automation
      "mouseless" # no more button clicky
      "raycast" # rofi/dmenu replacement
      "rectangle" # window snapping

      # Development
      "utm" # vms
      "obsidian" # digital twin
      "warp" # iterm2 + chatjippity
      "windsurf" # vscode + chatjippity
      "wireshark" # network analyzer

      "appgate-sdp-client" # ztna

      "ghostty"
    ];
  };
}
