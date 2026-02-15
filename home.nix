{ config, pkgs, inputs, ... }:

let
  inherit (pkgs) lib;
in {

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "dropbox"
        "firefox-bin"
        "firefox-bin-unwrapped"
        "google-chrome"
        "nosql-workbench"
        "spotify"
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
      dates = "weekly";
      options   = "--delete-older-than 30d";
    };
  };

  home = {
    username = "attakorn";
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin
    then "/Users/attakorn"
    else "/home/attakorn";
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
    inherit config pkgs;
  };

  fonts.fontconfig = {
    enable = true;
  };

  services = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-all;
    };

    lorri = {
      enable = true;
    };
  };
}
