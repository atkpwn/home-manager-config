{ pkgs }:

# pkgs.writeShellScriptBin "lolcat" ''
#   echo "hello world" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
# ''

pkgs.writeShellApplication {
  name = "lolcow";

  runtimeInputs = with pkgs; [ cowsay lolcat ];

  text = builtins.readFile ./lolcow.sh;
}
