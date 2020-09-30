with import <nixpkgs> {};

python2Packages.buildPythonApplication rec {
  pname = "sshuttle";
  version = "0.78.5";

  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "0vp13xwrhx4m6zgsyzvai84lkq9mzkaw47j58dk0ll95kaymk2x8";
  };

  nativeBuildInputs = [ makeWrapper python2Packages.setuptools_scm ];

  checkInputs = with python2Packages; [ mock pytest pytestcov pytestrunner flake8 ];

  runtimeDeps = [ coreutils openssh procps ] ++ stdenv.lib.optionals stdenv.isLinux [ iptables nettools ];

  postInstall = ''
    wrapProgram $out/bin/sshuttle \
      --prefix PATH : "${stdenv.lib.makeBinPath runtimeDeps}" \
  '';

}
