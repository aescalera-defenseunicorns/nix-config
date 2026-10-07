{
  pkgs,
  username,
  ...
}: let
  agentSandboxConfig = pkgs.writers.writeYAML "agent-sandbox.yaml" {
    vmType = "vz";
    base = [
      "template:_images/ubuntu-26.04"
    ];
    cpus = 8;
    memory = "16GiB";
    disk = "100GiB";
    mounts = [
      {
        location = "~/code";
        writable = true;
        # location = "/Users/${username}/code";
        # mountPoint = "/home/${username}/code";
      }
    ];
    mountType = "virtiofs";
    provision = [
      {
        mode = "system";
        script = ''
          apt-get update
          apt-get install -y sudo git curl ca-certificates build-essential golang-go gopls ripgrep eza gh clang tree zsh neovim oras git-delta

          # install docker
          # Add Docker's official GPG key:
          install -m 0755 -d /etc/apt/keyrings
          curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
          chmod a+r /etc/apt/keyrings/docker.asc

          # Add the repository to Apt sources:
          tee /etc/apt/sources.list.d/docker.sources <<EOF
          Types: deb
          URIs: https://download.docker.com/linux/ubuntu
          Suites: $(. /etc/os-release && echo "''${UBUNTU_CODENAME:-$VERSION_CODENAME}")
          Components: stable
          Architectures: $(dpkg --print-architecture)
          Signed-By: /etc/apt/keyrings/docker.asc
          EOF

          apt-get update
          apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
          groupadd docker
          usermod -aG docker ${username}

          # install uds
          APP=uds-cli
          ARCH=$(go env GOARCH)
          OS=$(go env GOOS)
          LATEST_VERSION=$(curl -s https://api.github.com/repos/defenseunicorns/$APP/releases/latest | jq -r '.name')
          curl -fsSL -o /usr/bin/uds https://github.com/defenseunicorns/$APP/releases/download/$LATEST_VERSION/''${APP}_''${LATEST_VERSION}_''${OS}_''${ARCH}
          chmod +x /usr/bin/uds


          # chsh -s /bin/zsh ${username}
        '';
      }
      {
        mode = "user";
        script = ''
          # git config
          git config --global core.pager delta
          git config --global interactive.diffFilter 'delta --color-only'
          git config --global delta.navigate true
          git config --global delta.dark true  # or `delta.light true`, or omit for auto-detection
          git config --global merge.conflictStyle zdiff3

          # install k3d
          curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

          # install UV
          curl -LsSf https://astral.sh/uv/install.sh | sh

          # install nodejs
          curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
          export NVM_DIR="$HOME/.nvm"
          [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
          nvm install node

          # ai tools
          npm install -g @openai/codex
          curl -fsSL https://herdr.dev/install.sh | sh
          npm install -g @openrig/cli
          rig setup --dry-run

          # agent skills
          npx skills add https://github.com/addyosmani/agent-skills         --global --agent '*' --yes --skill documentation-and-adrs
          npx skills add https://github.com/affaan-m/everything-claude-code --global --agent '*' --yes --skill golang-patterns
          npx skills add https://github.com/affaan-m/everything-claude-code --global --agent '*' --yes --skill golang-testing
          npx skills add https://github.com/szkocot/andrej-karpathy-skills  --global --agent '*' --yes --skill karpathy-guidelines
          npx skills add https://github.com/vercel-labs/skills              --global --agent '*' --yes --skill find-skills
          npx skills add https://github.com/obra/superpowers                --global --agent '*' --yes --skill systematic-debugging
          npx skills add https://github.com/juliusbrussee/caveman           --global --agent '*' --yes --skill caveman-commit
        '';
      }
    ];
    propagateProxyEnv = true;
  };
in {
  environment.systemPackages = with pkgs; [
    lima
  ];

  environment.shellAliases = {
    agent-sandbox-start = "${pkgs.lima}/bin/limactl start --yes --progress --name=agent-sandbox ${agentSandboxConfig}";
    agent-sandbox-shell = "${pkgs.lima}/bin/limactl shell agent-sandbox";
  };
}
