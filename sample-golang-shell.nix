let
  go113Tarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/6148f6360310366708dff42055a0ba0afa963101.tar.gz;
  pkgs = import <nixpkgs> {};
  goAlternate = import go113Tarball {};	
  
  drv = pkgs.stdenv.mkDerivation rec {
    name = "env";
    env = pkgs.buildEnv { name = name; paths = buildInputs; };
    buildInputs = [
      goAlternate.go_1_13
    ];

    shellHook = ''
      # export PS1="[nix@${name}:\W]\[$(tput sgr0)\] "
      export PS1="[\[\e[32m\]nix\[\e[m\]@\[\e[31m\]${name}\[\e[m\] \[\e[36m\]\W\[\e[m\]] "
      bind '"\e\e[C": forward-word'
      bind '"\e\e[D": backward-word'
    '';
  };
in drv
