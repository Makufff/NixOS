{ ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  # SSH client config - fix terminal type issues
  programs.ssh.extraConfig = ''
    Host *
      SetEnv TERM=xterm-256color
  '';
}
