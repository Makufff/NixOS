{ host, inputs, ... }:
let
  inherit (import ../hosts/${host}/variables.nix) sddmTheme;
in
{
  # Overlay custom derivations into nixpkgs so you can use pkgs.<name>
  additions =
    final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit host;
    };

  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: prev: {
    nur = inputs.nur.overlays.default;
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
    vesktop = prev.vesktop.override {
      withSystemVencord = false;
      withMiddleClickScroll = true;
    };
    discord = prev.discord.override {
      withVencord = true;
      withOpenASAR = true;
      enableAutoscroll = true;
    };
    gns3-gui = prev.gns3-gui.overrideAttrs (oldAttrs: rec {
      version = "2.2.55";
      src = prev.fetchFromGitHub {
        owner = "GNS3";
        repo = "gns3-gui";
        rev = "v${version}";
        sha256 = "1576fpjshvr989m0lwsmmpmn1rq1pi7abfgwbn8899hdm50yadpa";
      };
    });
    gns3-server = prev.gns3-server.overrideAttrs (oldAttrs: rec {
      version = "2.2.55";
      src = prev.fetchFromGitHub {
        owner = "GNS3";
        repo = "gns3-server";
        rev = "v${version}";
        sha256 = "13pyjn3nf8nhc5wgc2dwja4bihl1f6g2qhs0c4b9nsrcfsn12km3";
      };
      doCheck = false;
    });
  };
}
