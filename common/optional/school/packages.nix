{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
      daisy
  ];
}
