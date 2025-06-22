{ config, pkgs, inputs, ... }:

let
  inherit (pkgs) lib;
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./modules/xfce.nix
    ./modules/rofi.nix
    ./modules/emacs
    ./modules/kubernetes
  ];

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "dropbox"
        "google-chrome"
        "spotify"
        "firefox-bin"
        "firefox-release-bin-unwrapped"
      ];
    };
  };

  # needed for nixd to be able to find correct packages
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    gc = {
      automatic = true;
      frequency = "weekly";
      options   = "--delete-older-than 30d";
    };
  };

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
