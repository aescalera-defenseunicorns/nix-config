{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;

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

    # Host-specific configurations
    matchBlocks = {
      "github.com" = {
        user = "git";
      };

      "localhost" = {
        user = "root";
        port = 54629;
        identityFile = "/Users/aescalera/.local/share/containers/podman/machine/machine";
        identitiesOnly = true;

        # Additional configuration for localhost to accept ed25519
        extraOptions = {
          PubkeyAcceptedAlgorithms = "+ssh-ed25519";
          PubkeyAcceptedKeyTypes = "+ssh-ed25519";
        };
      };
    };
  };
}
