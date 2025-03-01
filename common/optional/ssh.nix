{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Yubikey login / sudo
  security.pam = {
    rssh.enable = true;
    services.sudo.rssh = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowPing = true;
}
