{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.stable; [
    jdk8_headless
  ];
  home-manager.users.osmo =
    { pkgs, ... }:
    {
      programs.helix.languages.language = [
        {
          name = "java";
          scope = "source.java";
          file-types = [ "java" ];
          auto-format = true;
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-servers = [ "${pkgs.jdt-language-server}" ];
        }
      ];
    };
}
