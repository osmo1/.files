{ config, ... }:
{
  imports = [
    ../../modules/containers
    #../../modules/containers/test.nix
  ] # ++ (if config.virtualisation.oci-containers.containers.deluge != null then [ ../../common/optional/vpn.nix ] else [])
  ;

  services.containers = {
  };
}
