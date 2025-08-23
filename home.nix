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
        "firefox-bin-unwrapped"
      ];
    };
  };

  # needed for nixd to be able to find correct packages
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    # see https://github.com/Misterio77/nix-config/blob/36f76f9a4e6dd45c692755858a248c26883184f5/hosts/common/global/nix.nix#L39
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;

    package = pkgs.nix; # required for generating nix.conf
    settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];

    gc = {
      automatic = true;
      frequency = "weekly";
      options   = "--delete-older-than 30d";
    };
  };

  home = {
    username = "attakorn";
    homeDirectory = "/home/attakorn";
    stateVersion = "25.11";
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

  fonts.fontconfig = {
    enable = true;
  };

  # https://tinted-theming.github.io/base16-gallery/
  colorScheme = inputs.nix-colors.colorSchemes.railscasts;
}
