{
  pkgs,
  config,
  ...
}:
{
  virtualisation = {
    oci-containers = {
      backend = "podman";
    };
    containers.enable = true;
    containers.containersConf.cniPlugins = with pkgs.stable; [
      cni-plugins
      dnsname-cni
    ];
    containers.storage.settings = {
      # Old rootfull storage
      # Had some problems also when setting up
      # storage = {
      #   driver = "overlay";
      #   runroot = "/run/containers/storage";
      #   graphroot = "/var/lib/containers/storage";
      #   rootless_storage_path = "/tmp/containers-$USER";
      #   options.overlay.mountopt = "nodev,metacopy=on";
      # };
      storage = {
        driver = "btrfs";
        rootless_storage_path = "${
          config.users.users.${config.hostSpec.username}.home
        }/.local/share/containers/storage";
      };
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    extraPackages = with pkgs; [
      zfs
      iputils
    ];

    defaultNetwork.settings = {
      # Required for container networking to be able to use names.
      dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    slirp4netns
    btrfs-progs
  ];

  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
    	export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';

  networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

  users.users."${config.hostSpec.username}".autoSubUidGidRange = true;
}
