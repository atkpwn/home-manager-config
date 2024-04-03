self: pkgs:

let
  myEmacs           = pkgs.emacs29;
  myEmacsPackages   = import ./packages.nix pkgs;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
{
  myEmacsWithPackages = (emacsWithPackages myEmacsPackages);
}
