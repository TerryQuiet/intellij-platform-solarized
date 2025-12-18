{
  description = "Rust Rover environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [ ];
            config.allowUnfree = true;
          };

          devShells.default = pkgs.mkShell {

            buildInputs = with pkgs; [
              claude-code
            ];

            JAVA_HOME = pkgs.jetbrains.jdk;

            packages = [
              pkgs.jetbrains.idea-community-bin

            ];

            shellHook = ''

            '';
          };
        };
    };
}
