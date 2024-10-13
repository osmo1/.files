{ pkgs, lib, ... }: {
    virtualisation = {
      oci-containers = { backend = "podman"; };
      containers.enable = true;
      containers.containersConf.cniPlugins = [ pkgs.cni-plugins pkgs.dnsname-cni ];
      containers.storage.settings = {
        storage = {
          driver = "overlay";
          runroot = "/run/containers/storage";
          graphroot = "/var/lib/containers/storage";
          rootless_storage_path = "/tmp/containers-$USER";
          options.overlay.mountopt = "nodev,metacopy=on";
        };
      };
   };

    virtualisation.podman = {
    	enable = true;
    	dockerCompat = true;
    	extraPackages = with pkgs; [ zfs iputils ];
        # TODO: need to figure out rootless
    	# rootless = {
    	#     enable = true;
    	#     setSocketVariable = true;
    	# };
    };
    environment.systemPackages = 
        (with pkgs; [
	slirp4netns
        ]);
    environment.extraInit = ''
      if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
        export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
      fi
    '';
    environment = if config.fileSystems."/persist".neededForBoot then {
      persistence."/persist".directories = [ "/etc/containers/" ]; }
      else {};
}
