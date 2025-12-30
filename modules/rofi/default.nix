{ pkgs, ... }:
let
  defaultFont = "JetBrainsMono Nerd Font";
in
{
  programs.rofi = {
    enable = true;
    cycle = true;
    extraConfig = {
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
    location = "center";
    plugins = [
      pkgs.rofi-emoji
    ];
    terminal = "alacritty";
    theme = ./tomorrow-night.rasi;
  };
}
