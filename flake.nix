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
    user = "attakorn";
    mkHomeConfigurationForAllHosts = user: hostConfigs: let
      hosts = builtins.attrNames hostConfigs;
      userHosts = map (host: "${user}@${host}") hosts;
    in
      nixpkgs.lib.genAttrs userHosts (userHost: let
        host = nixpkgs.lib.last (nixpkgs.lib.splitString "@" userHost);
        mkHome = config: home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit (config) system;
            overlays = [ ];
          };
          extraSpecialArgs = {
            useGlobalPkgs = true;
            inherit inputs;
          };
          modules = [
            inputs.nix-index-database.homeModules.nix-index
            inputs.emacs-with-env.homeModules.emacs-with-env
          ] ++ config.extraModules;
        };
      in
        mkHome (builtins.getAttr host hostConfigs)
      );
  in {
    homeConfigurations = mkHomeConfigurationForAllHosts user {
      "bigfoot" = {
        system = "x86_64-linux";
        extraModules = [ ./home.nix ];
      };
    };
  };
}
