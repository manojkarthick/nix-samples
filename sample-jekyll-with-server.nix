with import <nixpkgs> {};

let
  content = stdenv.mkDerivation {
    name = "example-website-content";

    src = fetchFromGitHub {
      owner = "jekyll";
      repo = "example";
      rev = "5eb1b902ca3bda6f4b50d4cfcdc7bc0097bac4b7";
      sha256 = "1jw35hmgx2gsaj2ad5f9d9ks4yh601wsxwnb17pmb9j02hl3vgdm";
    };

    installPhase = ''
      export JEKYLL_ENV=production
      # The site expects to be served as http://hostname/example/...
      ${pkgs.jekyll}/bin/jekyll build --destination $out/example
    '';
  };
in
let
  serveSite = pkgs.writeShellScriptBin "serveSite" ''
    # -F = do not fork
    # -p = port
    # -r = content root
    echo "Running server: visit http://localhost:8000/example/index.html"
    # See how we reference the content derivation by `${content}`
    ${webfs}/bin/webfsd -F -p 8000 -r ${content}
  '';
in
stdenv.mkDerivation {
  name = "server-environment";
  # Kind of evil shellHook - you don't get a shell you just get my site
  shellHook = ''
    ${serveSite}/bin/serveSite
  '';
}
