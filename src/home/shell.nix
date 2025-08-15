{lib, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    initContent = let
      p10kPrompt = lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';
      zshConfig = lib.mkOrder 1000 ''
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/.cargo/bin:$PATH"
        export PATH="$HOME/go/bin:$PATH"

        export EDITOR=nvim
        export PAGER=bat
        export MANPAGER=bat

        export LC_ALL=en_US.UTF-8
        export LANG=en_US.UTF-8

        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    in
      lib.mkMerge [p10kPrompt zshConfig];

    antidote = {
      enable = true;
      plugins = [
        "rupa/z"

        "ohmyzsh/ohmyzsh path:lib"
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/command-not-found"
        "ohmyzsh/ohmyzsh path:plugins/extract"
        "ohmyzsh/ohmyzsh path:plugins/gpg-agent"

        "romkatv/powerlevel10k"

        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
      ];
      useFriendlyNames = true;
    };
  };

  home.shellAliases = {
    k = "kubectl";
    m = "make";
    # grep = "rg";
    ls = "eza -a --long --git";
    vi = "nvim";
    vim = "nvim";
    diff = "delta";
    cat = "bat";
    tag = "git tag -s";
    push = "git push -u origin $(git rev-parse --abbrev-ref HEAD)";

    # if you have the same gpg keys on more than one yubikey/smartcard, this will enable gpg to find the keys on other smartcards.
    sc-relearn = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
}
