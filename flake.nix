{
  description = "Plus Ultra";

  inputs = {
    # NixPkgs (nixos-23.11)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # NixPkgs Unstable (nixos-unstable)
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager (release-22.05)
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    #lix = {
    #  url = "git+https://git.lix.systems/lix-project/lix";
    #  flake = false;
    #};
    lix-module = {
      #url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      #inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware Configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Generate System Images
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib";
    # snowfall-lib.url = "path:/home/short/work/@snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";


    # Snowfall Flake
    flake.url = "github:snowfallorg/flake";
    flake.inputs.nixpkgs.follows = "unstable";


    # Comma
    comma.url = "github:nix-community/comma";
    comma.inputs.nixpkgs.follows = "unstable";

    # Veracrypt
    veracrypt.url = "github:NixOs/nixpkgs/4054e4f776b62f59acafce83d6c30a839f913fc7";
    #veracrypt.inputs.nixpkgs.follows = "unstable";

    # Tmux
    tmux.url = "github:jakehamilton/tmux";
    tmux.inputs = {
      nixpkgs.follows = "nixpkgs";
      unstable.follows = "unstable";
    };

    #WSL
    nixos-wsl.url = "github:nix-community/nixos-wsl";

    # Binary Cache
    attic = {
      url = "github:zhaofengli/attic";

      # FIXME: A specific version of Rust is needed right now or
      # the build fails. Re-enable this after some time has passed.
      inputs.nixpkgs.follows = "unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };


    # GPG default configuration
    gpg-base-conf = {
      url = "github:drduh/config";
      flake = false;
    };


    # sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hosted Sites
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "plusultra";
          title = "Plus Ultra";
        };

        namespace = "plusultra";
      };
    };
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };

      overlays = with inputs; [
        tmux.overlay
        flake.overlays.default
        lix-module.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
      ];

      systems.hosts.wsl.modules = with inputs; [
        nixos-wsl.nixosModules.wsl
      ];

      deploy = lib.mkDeploy {inherit (inputs) self;};

      checks =
        builtins.mapAttrs
        (system: deploy-lib:
          deploy-lib.deployChecks inputs.self.deploy)
        inputs.deploy-rs.lib;
    };
}
