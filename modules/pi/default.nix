{ config, ... }:
let
  piConfigHome = "${config.xdg.configHome}/pi";
in
{
  home.file = {
    "${piConfigHome}/AGENTS.md".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/AGENTS.md";
    "${piConfigHome}/agent/skills".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/skills";
  };

  programs.pi-coding-agent = {
    enable = true;
    configDir = "${piConfigHome}";
  };
}
