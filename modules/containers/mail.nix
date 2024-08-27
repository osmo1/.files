{}: {
  #TODO: this is very work in progress
  containers.nextcloud = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.11.200";
        localAddress = "192.168.100.2";

        forwardPorts = [
            {
            containerPort = 80;
            hostPort = 280;
            protocol = "tcp";
            }{
            containerPort = 443;
            hostPort = 2443;
            protocol = "tcp";
            }
        ];

        ephemeral = true;

        bindMounts = {
            "/data" = {
                hostPath = "/home/osmo/nextcloud/site";
                isReadOnly = false;
            };
            "/data/data/osmo/files/" = {
                hostPath = "/home/osmo/nextcloud/files";
                isReadOnly = false;
            };
            "/db" = {
                hostPath = "/home/osmo/nextcloud/db";
                isReadOnly = false;
            };
            #"/syncthing" = {
                #hostPath = "/home/osmo/syncthing/school";
                #isReadOnly = false;
            #};
        };
          config = { config, pkgs, lib, ... }: { 
	    services.maddy = {
		  enable = true;
		  primaryDomain = "localhost";
		  ensureAccounts = [
		    "osmo@example.org"
		    "postmaster@example.org"
		  ];
		  ensureCredentials = {
		    # Do not use this in production. This will make passwords world-readable
		    # in the Nix store
		    "osmo@example.org".passwordFile = "${config.sops.secrets.'containers/maddy/user1'.path}";
		    "postmaster@example.org".passwordFile = "${config.sops.secrets.'containers/maddy/postmaster'.path}";
		  };
		};
		openFirewall = true;
		  tls = {
		    loader = "acme";
		    extraConfig = ''
		      email put-your-email-here@example.org
		      agreed # indicate your agreement with Let's Encrypt ToS
		      host ${config.services.maddy.primaryDomain}
		      challenge dns-01
		      ${cfg...}
		      '';
		  };
		  # Enable TLS listeners. Configuring this via the module is not yet
		  # implemented, see https://github.com/NixOS/nixpkgs/pull/153372
		  config = builtins.replaceStrings [
		    "imap tcp://0.0.0.0:143"
		    "submission tcp://0.0.0.0:587"
		  ] [
		    "imap tls://0.0.0.0:993 tcp://0.0.0.0:143"
		    "submission tls://0.0.0.0:465 tcp://0.0.0.0:587"
		  ] options.services.maddy.config.default;
		  # Reading secrets from a file. Do not use this example in production
		  # since it stores the keys world-readable in the Nix store.
		  };
		  services.nsd = {
			  enable = true;
			  interfaces = [
			    "0.0.0.0"
			    "::"
			  ]; 
			  zones."example.org.".data = let
			    domainkey = ''
			      v=DKIM1; k=rsa; p=${
				lib.fileContents( /var/lib/maddy/dkim_keys/example.org_default.dns )}'';
			    segments = ((lib.stringLength domainkey) / 255);
			    domainkeySplitted = map (x: lib.substring (x*255) 255 domainkey) (lib.range 0 segments);
			  in ''
			    @ SOA ns.example.org noc.example.org 666 7200 3600 1209600 3600
			    @ A 1.2.3.4
			    @ AAAA abcd::eeff
			    @ MX 10 mx1
			    mx1 A 1.2.3.4
			    mx1 AAAA abcd::eeff
			    @ TXT "v=spf1 mx ~all"
			    mx1 TXT "v=spf1 mx ~all"
			    _dmarc TXT "v=DMARC1; p=quarantine; ruf=mailto:postmaster@example.org
			    _mta-sts TXT "v=STSv1; id=1"
			    _smtp._tls TXT "v=TLSRPTv1;rua=mailto:postmaster@example.org"
			    default._domainkey TXT "${lib.concatStringsSep "\" \"" domainkeySplitted}"
			  '';
			};
			caddy = {                                  
			  enable = true;                                              
			  virtualHosts."mta-sts.example.org".extraConfig = ''
			    encode gzip
			    file_server
			    root * ${
			      pkgs.runCommand "testdir" {} ''
				mkdir -p "$out/.well-known"
				echo "
				  version: STSv1
				  mode: enforce
				  max_age: 604800
				  mx: mx1.example.org
				" &gt; "$out/.well-known/mta-sts.txt"
			      ''
			    }
			  '';
			  virtualHosts."autoconfig.example.org".extraConfig = ''
			    reverse_proxy http://localhost:1323              
			  '';             
			};

			services.maddy.config = builtins.replaceStrings ["msgpipeline local_routing {"] [''msgpipeline local_routing {
			  check {
			    rspamd {
			      api_path http://localhost:11334
			    }
			  }''] options.services.maddy.config.default;

			services.rspamd = {
			  enable = true;
			  locals."dkim_signing.conf".text = ''
			    selector = "default";
			    domain = "project-insanity.org";
			    path = "/var/lib/maddy/dkim_keys/$domain_$selector.key";
			  '';
			};

			systemd.services.rspamd.serviceConfig.SupplementaryGroups = [ "maddy" ];
			services.go-autoconfig = {
			  enable = true;
			  settings = {
			    service_addr = ":1323";
			    domain = "autoconfig.example.org";
			    imap = {
			      server = "example.org";
			      port = 993;
			    };
			    smtp = {
			      server = "example.org";
			      port = 587;
			    };
			  };
			};
			services.nsd.zones."example.org.".data = ''
			  [...]
			  _autodiscover._tcp SRV 0 0 443 autoconfig
			'';


	 networking.firewall.allowedTCPPorts = [ 993 465 ];
		  }
		  };
  };
}
