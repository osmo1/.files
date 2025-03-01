{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets."wireguard/oraakeli/private".path = "/persist/run/secrets/wireguard/oraakeli/private";
  sops.secrets."wireguard/oraakeli/preshare".path =
    "/persist/run/secrets/wireguard/oraakeli/preshare";
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.13.13.2" ];
      listenPort = 51820;
      privateKeyFile = config.sops.secrets."wireguard/oraakeli/private".path;
      dns = [
        "10.13.13.1"
      ];

      peers = [
        {
          publicKey = "w4O5dZkMcHkoMci+DyYdsp21BdAQFq6rPj5dDy5FSSw=";
          presharedKeyFile = config.sops.secrets."wireguard/oraakeli/preshare".path;

          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "158.179.207.29:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
