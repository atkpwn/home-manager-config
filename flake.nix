{
  description = "Home Manager configuration of attakorn";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-with-env = {
      url = "github:atkpwn/emacs-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs: let
    mkHomeConfigurationForAllHosts = hostConfigs: let
      userHosts = builtins.attrNames hostConfigs;
    in
      nixpkgs.lib.genAttrs userHosts (userHost: let
        username = builtins.head (nixpkgs.lib.splitString "@" userHost);
        hostname = nixpkgs.lib.last (nixpkgs.lib.splitString "@" userHost);
        mkHome = config: home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit (config) system;
            overlays = [ ];
          };
          extraSpecialArgs = {
            useGlobalPkgs = true;
            inherit
              inputs
              username
              hostname
            ;
          };
          modules = [
            ./home.nix
            inputs.nix-index-database.homeModules.nix-index
            inputs.emacs-with-env.homeModules.emacs-with-env
          ] ++ config.extraModules;
        };
      in
        mkHome (builtins.getAttr userHost hostConfigs)
      );
  in {
    homeConfigurations = mkHomeConfigurationForAllHosts {
      "attakorn@bigfoot" = {
        system = "x86_64-linux";
        extraModules = [
          ./modules/xfce
          ./modules/rofi
          ./modules/kubernetes
        ];
      };
      "attakorn@wuerfel" = {
        # run hostname command; if the hostname isn't set then:
        # sudo scutil --set HostName wuerfel
        system = "aarch64-darwin";
        extraModules = [
          ./modules/kubernetes
          ./modules/einkonbini
        ];
      };
    };
  };
}
