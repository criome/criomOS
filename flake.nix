{
  description = "CriomOS";

  inputs = {
    hob.url = "github:criome/hob/17thScorpio5918AM";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    attic.url = "github:zhaofengli/attic";
  };

  outputs = inputs:
    inputs.flake-parts.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "riscv64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      imports = [ ];
    };
}
