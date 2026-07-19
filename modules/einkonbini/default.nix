{ config, pkgs, ... }:

let
  inherit (pkgs) lib;
  home = config.home.homeDirectory;
  moduleHome = "${config.xdg.configHome}/home-manager/modules/einkonbini";
in {
  programs = {
    zsh.dirHashes = {
      konbini = "${home}/projects/einkonbini";
    };

    git = {
      settings = {
        "includeIf \"gitdir:~/projects/einkonbini/\"".path =
          "${moduleHome}/git.config";
      };
    };

    ssh = {
      extraConfig = lib.mkOrder 1200 ''
        Include ${moduleHome}/ssh.config
      '';
    };
  };
}
