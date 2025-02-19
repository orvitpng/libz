{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.treefmt-nix.flakeModule ];

      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = [ pkgs.zig ];
          };

          treefmt.programs = {
            # zig
            zig.enable = true;
            # nix
            nixfmt.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            # shell
            shfmt.enable = true;
            shellcheck.enable = true;
            # markdown
            mdformat.enable = true;
          };
        };
    };
}
