{ pkgs, ... }:

let
  myEmacsWithPackages = let
    myEmacs = if pkgs.stdenv.hostPlatform.isLinux
    then pkgs.emacs-gtk
    else pkgs.emacs-macport;
    # xwidgets requires GTK as X window toolkit
    myEmacsWithXWidgets = myEmacs.overrideAttrs (o: {
      # see example configure flags from jwiegley
      # https://github.com/jwiegley/nix-config/blob/d48861de5d2d52e84403213a6110389c69c0bb4c/overlays/10-emacs.nix#L700
      configureFlags = o.configureFlags ++ [
        "--with-xwidgets" # NOTE: 2025.05.11 not build due to requiring an old GTK verion that is no longer in nixpkgs
      ];
    });
    myEmacsPackages = pkgs.callPackage ./epackages {};
    emacsWithPackages =
      (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
  in
    emacsWithPackages myEmacsPackages;
in
{
  home = {
    sessionVariables = {
      EDITOR = "emacsclient";
    };
    packages = with pkgs; [
      myEmacsWithPackages

      nerd-fonts.jetbrains-mono

      # required by epackages.dirvish
      ffmpegthumbnailer
      mediainfo
      poppler_utils
      fd
      imagemagick

      direnv
    ];
  };
}
