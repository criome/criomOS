{ pkgs, lib, hyraizyn, kor, criomOS, uyrld, homeModule, ... }:
let
  inherit (builtins) mapAttrs;
  inherit (lib) mkOverride;
  inherit (uyrld) mkHomeConfig pkdjz;

  iuzMetylModule = hyraizyn.astra.mycin.spici == "metyl";
  profile = { dark = false; };

  mkUserConfig = name: user:
    { _module.args = { inherit user profile; }; };

in
{
  boot = {
    supportedFilesystems = mkOverride 10 [ "btrfs" "vfat" "xfs" "ntfs" ];
  };

  hardware.enableAllFirmware = iuzMetylModule;

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit kor pkdjz uyrld hyraizyn; };
    sharedModules = [ homeModule ];
    useGlobalPkgs = true;
    users = mapAttrs mkUserConfig hyraizyn.users;
  };

  isoImage = {
    isoBaseName = "criomOS";
    volumeID = "criomOS-${criomOS.shortRev}-${pkgs.stdenv.hostPlatform.uname.processor}";

    makeUsbBootable = true;
    makeEfiBootable = true;
  };

}
