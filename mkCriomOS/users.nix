{ hyraizyn, config, kor, pkgs, ... }:
let
  inherit (builtins) filter mapAttrs attrNames hasAttr
    concatStringsSep concatMap;
  inherit (kor) optionals optional optionalString mkIf optionalAttrs;

  inherit (hyraizyn) astra exAstriz users;
  inherit (astra.spinyrz) adminEseseitcPreCriomes;

  userNeimz = attrNames users;

  mkEseseitcString = preCriome: concatStringsSep " "
    [ "ed25519" preCriome.eseseitc ];

  mkUser = attrNeim: user:
    let
      inherit (user) trost spinyrz;
      inherit (user.spinyrz) eseseitcyz hazPreCriome;

    in
    optionalAttrs (trost > 0) {
      name = user.neim;

      useDefaultShell = true;
      isNormalUser = true;

      openssh.authorizedKeys.keys = eseseitcyz;

      extraGroups = [ "audio" ]
        ++
        (optional (config.programs.sway.enable == true) "sway")
        ++
        (optionals (trost >=2)
          ([ "video" ] ++
            (optional (config.networking.networkmanager.enable == true)) "networkmanager"))
        ++
        (optionals (trost >= 3) [
          "adbusers"
          "nixdev"
          "systemd-journal"
          "dialout"
          "plugdev"
          "storage"
          "libvirtd"
        ]);
    };

  mkUserUsers = mapAttrs mkUser users;


  rootUserAkses = {
    root = {
      openssh.authorizedKeys.keys = adminEseseitcPreCriomes;
    };
  };

in
{ users = { users = mkUserUsers // rootUserAkses; }; }
