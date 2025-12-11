{
  lib,
  userfullname,
  useremail,
  usersigningkey,
  ...
}: {
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.gitconfig
  '';

  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        features = "side-by-side";
      };
    };

    git = {
      enable = true;
      lfs.enable = true;

      includes = [
        {
          # use diffrent email for github
          path = "~/code/projects/oss/github.com/.gitconfig";
          condition = "gitdir:~/code/projects/oss/github.com/";
        }
      ];

      settings = {
        signing = {
          # key = "F6F06231397E03C184D461C792FEE6EDB2019086";
          key = usersigningkey;
          signByDefault = true;
        };

        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        http.postBuffer = 524288000;

        user.name = userfullname;
        user.email = useremail;

        alias = {
          # common aliases
          br = "branch";
          co = "checkout";
          st = "status";
          ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
          ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
          cm = "commit -m";
          ca = "commit -am";
          dc = "diff --cached";
          amend = "commit --amend -m";

          # aliases for submodule
          update = "submodule update --init --recursive";
          foreach = "submodule foreach";
        };
      };
    };
  };
}
