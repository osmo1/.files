{ config, ... }: {
  sops.secrets.k3s = {};
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets.k3s.path;
    extraFlags = toString ([
            "--write-kubeconfig-mode \"0644\""
            "--cluster-init"
    ] ++ (if meta.hostname == "klusteri-0" then [] else [
	      "--server https://klusteri-0:6443"
    ]));
    serverAddr = if config.networking.hostName == "klusteri-0" then "" else "https://klusteri-0:6443";
    clusterInit = if config.networking.hostName == "klusteri-0" then true else false;
  };
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/rancher"
      "/var/lib/kubelet"
    ];
    files = [
    ];
  };
  networking.firewall.allowedTCPPorts = [ 6443 8080 2379 2380 ];
}
