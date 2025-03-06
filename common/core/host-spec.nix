{ config, ... }: {
      imports = (if config.hostSpec.desktop == null then [] else [ ../../common/optional/desktop/${config.hostSpec.desktop} ])
      ++ (if config.hostSpec.isServer == true then [] else [ ../../common/optional/cli ]);
}
