{
  description = "CriomOS";

  inputs.atom.url = "github:LiGoldragon/atom";

  outputs =
    { atom, ... }:
    atom.mkAtomicFlake {
      manifest = ./. + "/nix/CriomOS@.toml";
      noSystemManifest = ./. + "/nix/CriomOS-lib@.toml";
    };
}
