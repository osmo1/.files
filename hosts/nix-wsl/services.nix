{
  imports = [
    ../../modules/containers
  ];

  services.containers = {
    crafty = {
      enable = false;
      dataLocation = "/home/osmo/crafty";
      uiPort = 38000;
      timeZone = "Europe/Helsinki";
      enableHomePage = false;
      options = {
        portOffset = 0;
        enableRcon = false;
      };
    };
    jellyarr = {
      enable = false;
      dataLocation = "/home/osmo/jellyarr";
      uiPortStart = 2080;
      timeZone = "Europe/Helsinki";
      enableHomePage = false;
    };
  };
}
