{ config, pkgs, lib, nix-colors, ... }:

let
  linuxAttrs = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux;
in {
  imports = [
    nix-colors.homeManagerModules.default
  ];

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "google-chrome"
        "spotify"
      ];
    };

    overlays = [ (import ./overlays/emacs/emacs.nix) ];
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
    inherit pkgs config lib;
  };

  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    # stop beeping
    configFile."autostart/beep.desktop".text = builtins.readFile ./config/beep.desktop;
  };

  # https://tinted-theming.github.io/base16-gallery/
  colorScheme = nix-colors.colorSchemes.ia-dark;

  xfconf.settings = linuxAttrs {
    xfwm4 = {
      "general/workspace_count" = 2;
    };
    xfce4-panel = {
      "plugins/plugin-2/grouping" = false;
    };
    xfce4-keyboard-shortcuts = {
      "xfwm4/custom/<Super>Down"   = "tile_down_key";
      "xfwm4/custom/<Super>Up"     = "tile_up_key";
      "xfwm4/custom/<Super>Left"   = "tile_left_key";
      "xfwm4/custom/<Super>Right"  = "tile_right_key";
      "xfwm4/custom/<Super>Return" = "maximize_window_key";
      "xfwm4/custom/<Primary><Alt><Shift>Left"  = "move_window_prev_workspace_key";
      "xfwm4/custom/<Primary><Alt><Shift>Right" = "move_window_next_workspace_key";
    };
    xsettings = {
      "Net/ThemeName" = "Zukitre-dark";
    };
  };
}
