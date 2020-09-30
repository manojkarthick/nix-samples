with import <nixpkgs> {};

let
  wmiPackage = pkgs.writeShellScriptBin "whatsMyIp" ''
    ${pkgs.curl}/bin/curl -sL http://httpbin.org/get | ${pkgs.jq}/bin/jq -r '.origin'
  '';
in
stdenv.mkDerivation rec {
  name = "test-environment";
  buildInputs = [ wmiPackage];
}

