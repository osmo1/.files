{ lib, pkgs, ... }:{
  boot.initrd.systemd.enable = lib.mkDefault true;
  security.tpm2.enable = true;
security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
users.users.osmo.extraGroups = [ "tss" ];  # tss group has access to TPM devices
  boot.initrd.availableKernelModules = ["tpm_tis" "tpm" "tpm_tis_core"]; 
}
