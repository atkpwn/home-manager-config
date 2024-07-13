{
  trivialBuild,
  fetchFromGitHub,
  compat
}:
trivialBuild rec {
  pname = "org-modern-indent";
  version = "0.1.4";
  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vtbaa3MURnAI1ypLueuSfgAno0l51y3Owb7g+jkK6JU=";
  };
  # elisp dependencies
  propagatedUserEnvPkgs = [
    compat
  ];
  buildInputs = propagatedUserEnvPkgs;
}
