{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Global SSH configuration with RSA support added
    extraConfig = ''
      # Signature algorithms including RSA support
      CASignatureAlgorithms ecdsa-sha2-nistp256,sk-ecdsa-sha2-nistp256@openssh.com,rsa-sha2-512,rsa-sha2-256,ssh-rsa

      # Public key algorithms including RSA support
      PubkeyAcceptedAlgorithms ecdsa-sha2-nistp256,ecdsa-sha2-nistp256-cert-v01@openssh.com,sk-ecdsa-sha2-nistp256-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256,ssh-rsa,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com

      # MAC algorithms
      MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-256

      # Key exchange algorithms
      KexAlgorithms ecdh-sha2-nistp256

      # Host key algorithms including RSA support
      HostKeyAlgorithms ecdsa-sha2-nistp256-cert-v01@openssh.com,sk-ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp256,sk-ecdsa-sha2-nistp256@openssh.com,rsa-sha2-512,rsa-sha2-256,ssh-rsa,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com

      # Hostbased accepted algorithms including RSA support
      HostbasedAcceptedAlgorithms ecdsa-sha2-nistp256,ecdsa-sha2-nistp256-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256,ssh-rsa,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com
    '';

    # Include additional configurations
    includes = [
      "/Users/aescalera/.colima/ssh_config"
    ];
    settings = {
      localhost = {
        User = "root";
        Port = 54629;
        IdentityFile = "/Users/aescalera/.local/share/containers/podman/machine/machine";
        IdentitiesOnly = true;

        # Additional configuration for localhost to accept ed25519
        PubkeyAcceptedAlgorithms = "+ssh-ed25519";
        PubkeyAcceptedKeyTypes = "+ssh-ed25519";
      };
      "github.com" = {
        user = "git";
      };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}
