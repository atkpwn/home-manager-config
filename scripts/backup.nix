{ pkgs }:

pkgs.writeShellApplication {
  name = "backup";

  runtimeInputs = with pkgs; [
    zstd
    pv
    gnupg
  ];

  text = builtins.readFile ./backup.sh;
}
