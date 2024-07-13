self: pkgs:

let
  # xwidgets requires GTK as X window toolkit
  myEmacs = pkgs.emacs-gtk.overrideAttrs (o: {
    # see example configure flags from jwiegley
    # https://github.com/jwiegley/nix-config/blob/d48861de5d2d52e84403213a6110389c69c0bb4c/overlays/10-emacs.nix#L700
    configureFlags = o.configureFlags ++ [
      "--with-xwidgets"
    ];
  });
  myEmacsPackages   = import ./packages.nix pkgs;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
{
  myEmacsWithPackages = (emacsWithPackages myEmacsPackages);
}
