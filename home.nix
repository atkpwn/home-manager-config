{ config, pkgs, lib, ... }:

let
  linuxAttrs = lib.optionalAttrs pkgs.stdenv.targetPlatform.isLinux;
in {
  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "google-chrome"
        "spotify"
      ];
    };

    overlays = [ (import ./overlays/emacs/overlay.nix) ];
  };

  home = {
    username = "attakorn";
    homeDirectory = "/home/attakorn";
    stateVersion = "22.11";
    packages = import ./packages.nix { inherit pkgs; };
    sessionPath = [
      (toString ./bin)
    ];
    sessionVariables = {
      EDITOR = "emacsclient";
    };
    file = linuxAttrs {
      "${config.xdg.configHome}/xfce4/helpers.rc".text = ''
        WebBrowser=brave
        TerminalEmulator=alacritty
      '';
    };
  };

  programs = import ./programs.nix {
    inherit pkgs;
    inherit lib;
  };

  fonts.fontconfig.enable = true;

  xdg.enable = true;

  xfconf.settings = linuxAttrs {
    xfce4-keyboard-shortcuts = {
      "xfwm4/custom/<Super>Down"   = "tile_down_key";
      "xfwm4/custom/<Super>Up"     = "tile_up_key";
      "xfwm4/custom/<Super>Left"   = "tile_left_key";
      "xfwm4/custom/<Super>Right"  = "tile_right_key";
      "xfwm4/custom/<Super>Return" = "maximize_window_key";
    };
  };
}
