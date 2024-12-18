{ config, pkgs, inputs, ... }:

let
  inherit (pkgs) lib;
  linuxAttrs = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux;
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "google-chrome"
        "spotify"
      ];
    };

    overlays = [ (import ./overlays/emacs) ];
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
    configFile."autostart/beep.desktop".text = builtins.readFile ./config/xfce/beep.desktop;
  };

  # https://tinted-theming.github.io/base16-gallery/
  colorScheme = inputs.nix-colors.colorSchemes.railscasts;

  xfconf.settings = linuxAttrs import ./config/xfce/xfconf.nix;

}
