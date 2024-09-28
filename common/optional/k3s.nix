{ config, ... }: {
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops-nix.secrets."k3s/${config.networking.hostname}".path;
    serverAddr = if config.networking.hostname == "klusteri-0" then "" else "https://klusteri-0:6443";
  };
}
