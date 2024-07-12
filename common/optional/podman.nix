{
    virtualisation.oci-containers = { backend = "podman"; };
    virtualisation.containers.containersConf.cniPlugins = [ pkgs.cni-plugins pkgs.dnsname-cni ];
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
}
