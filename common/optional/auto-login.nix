{
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "osmo";
  };
  # security.pam.services = {
  #   login = {
  #     enableKwallet = true;
  #     kwallet = {
  #       enable = true;
  #       #package = pkgs.kdePackages.kwallet-pam;
  #     };
  #   };
  #   kde = {
  #     enableKwallet = true;
  #     kwallet = {
  #       enable = true;
  #       #package = pkgs.kdePackages.kwallet-pam;
  #     };
  #   };
  #   sddm.enableKwallet = true;
  # };
}
