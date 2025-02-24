{ pkgs, ... }:

epkgs:
let
  org-modern-indent = (pkgs.callPackage ./org-modern-indent.nix { inherit pkgs epkgs; });
in with epkgs; [
  ace-window
  aggressive-indent
  auctex
  avy
  avy-zap
  back-button
  blamer
  cider
  clj-refactor
  cmake-font-lock
  citar
  citar-embark
  consult
  consult-dir
  consult-eglot
  consult-project-extra
  corfu
  dashboard
  deno-ts-mode
  devdocs
  diff-hl
  diffview
  diminish
  dirvish
  dockerfile-mode
  doom-modeline
  doom-themes
  ef-themes
  elfeed
  elfeed-webkit
  embark
  embark-consult
  expand-region
  flycheck-clojure
  helpful
  highlight-indentation
  jinx
  jq-format
  magit
  magit-delta
  marginalia
  markdown-mode
  minions
  multiple-cursors
  nerd-icons-completion
  nerd-icons-corfu
  nerd-icons-dired
  nginx-mode
  no-littering
  openwith
  orderless
  org-appear
  org-modern
  org-modern-indent
  org-roam
  org-superstar
  pdf-tools
  perspective
  popper
  project-treemacs
  pyvenv
  rainbow-delimiters
  rg
  selected
  treemacs
  treemacs-magit
  treemacs-nerd-icons
  treesit-grammars.with-all-grammars
  undo-tree
  unfill
  use-package
  vertico
  visual-fill-column
  which-key
  yasnippet
  zoom-window
]
++
[
  cargo-mode
  clojure-ts-mode
  kotlin-mode
  nix-mode
  nix-ts-mode
  shfmt
]
