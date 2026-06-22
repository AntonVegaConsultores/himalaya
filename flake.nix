{
  description = "himalaya — correo Vega Consultores (himalaya + mbsync)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.himalaya  # cliente de correo (lee del Maildir, envía por SMTP)
            pkgs.isync     # mbsync: espejo IMAP -> Maildir local
          ];
          shellHook = ''
            echo "himalaya + mbsync · sync: bin/sync-mail · config: config.toml"
          '';
        };
      });
}
