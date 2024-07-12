{
    imports = [
        ../../modules/containers
    ]
    services.docker.crafty = {
        enable = true;
        version = "latest";
        volumesBase = "/home/osmo/crafty";
        webUIPort = 380;
    };
}
