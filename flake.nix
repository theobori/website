{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-utils.url = "github:numtide/flake-utils";
    my-website-carbon-badges.url = "github:theobori/my-website-carbon-badges";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      flake-utils,
      my-website-carbon-badges,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        my-website-carbon-badges-pkg = my-website-carbon-badges.packages.${system}.default;

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        packages = {
          default = pkgs.callPackage ./. { inherit my-website-carbon-badges-pkg; };
        };

        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nodejs
            ];
          };
        };

        formatter = treefmtEval.config.build.wrapper;

        checks = {
          formatting = treefmtEval.config.build.check self;
        };
      }
    );
}
