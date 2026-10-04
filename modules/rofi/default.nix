{ pkgs, ... }:
let
  defaultFont = "JetBrainsMono Nerd Font";
in
{
  programs.rofi = {
    enable = true;
    settings = {
      cycle = true;
      location = 0; # center
      terminal = "ghostty";
      modi = "run,filebrowser,emoji";
      font = defaultFont + " 14";
      kb-cancel = "!Alt+space,Escape,Control+g";
      display-combi = " ";
      display-emoji = "󰱨 ";
      display-filebrowser = " ";
      display-run = " ";
      display-window = " ";
      display-workspace = "";
      # drun-display-format = "{name}";
      show-icons = true;
      sidebar-mode = true;
      window-format = "{c} · {t}";
    };
    plugins = [
      pkgs.rofi-emoji
    ];
    theme = ./tomorrow-night.rasi;
  };
}
