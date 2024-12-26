{ config, pkgs, inputs, ... }:

let
  inherit (pkgs) lib;
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./modules/xfce.nix
    ./modules/rofi.nix
    ./modules/emacs
  ];

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "google-chrome"
        "spotify"
      ];
    };
  };

  # needed for nixd to be able to find correct packages
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  home = {
    username = "attakorn";
    homeDirectory = "/home/attakorn";
    stateVersion = "22.11";
    keyboard = {
      layout = "us,th";
      variant = "altgr-intl,";
      options = "grp:win_space_toggle";
    };
    packages = import ./packages.nix { inherit pkgs; };
    sessionPath = [
      (toString ./bin)
    ];
  };

  programs = import ./programs.nix {
    inherit pkgs config lib;
  };

  fonts.fontconfig.enable = true;

  # https://tinted-theming.github.io/base16-gallery/
  colorScheme = inputs.nix-colors.colorSchemes.railscasts;
}
