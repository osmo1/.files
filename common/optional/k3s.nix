{ config, ... }: {
  sops.secrets."k3s/${config.networking.hostName}" = {};
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets."k3s/${config.networking.hostName}".path;
    extraFlags = toString ([
	    "--write-kubeconfig-mode \"0644\""
	    "--cluster-init"
    ];
    serverAddr = if config.networking.hostName == "klusteri-0" then "" else "https://klusteri-0:6443";
  };
}
