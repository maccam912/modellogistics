let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    buildInputs = [
        pkgs.elixir
	pkgs.nodejs
    ];
  }
