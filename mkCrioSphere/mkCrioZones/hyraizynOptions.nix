{ config, lib, metastrizSpiciz, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum str attrsOf submodule nullOr bool int
    listOf attrs;

  inherit (metastrizSpiciz) metastriNeimz astriSpiciz
    magnytiud sistymz komynUserOptions mycinSpici IoOptions;

  astriOptions = {
    neim = mkOption {
      type = str;
    };

    spici = mkOption {
      type = enum astriSpiciz;
      default = "sentyr";
    };

    trost = mkOption {
      type = enum magnytiud;
    };

    criomOSNeim = mkOption {
      type = str;
    };

    sistym = mkOption {
      type = enum sistymz;
    };

    nbOfBildKorz = mkOption {
      type = int;
      default = 1;
    };

    saiz = mkOption {
      type = enum magnytiud;
    };

    mycin = mkOption {
      type = mycinSpici;
    };

    yggPreCriome = mkOption {
      type = nullOr str;
      default = null;
    };

    yggAddress = mkOption {
      type = nullOr str;
      default = null;
    };

    yggSubnet = mkOption {
      type = nullOr str;
      default = null;
    };

    eseseitc = mkOption {
      type = nullOr str;
      default = null;
    };

    niksPreCriome = mkOption {
      type = nullOr str;
      default = null;
    };

    linkLocalIPs = mkOption {
      type = listOf str;
      default = [ ];
    };

    neksysIp = mkOption {
      type = nullOr str;
      default = null;
    };

    wireguardPreCriome = mkOption {
      type = nullOr str;
      default = null;
    };

    wireguardUntrustedProxies = mkOption {
      type = listOf attrs;
      default = [ ];
    };

    spinyrz = mkOption {
      type = attrs;
      default = { };
    };

    typeIs = mkOption {
      type = attrs;
      default = { };
    };
  };

  metastraSubmodule = {
    options = {
      neim = mkOption {
        type = enum metastriNeimz;
      };

      spinyrz = mkOption {
        type = attrs;
        default = { };
      };
    };
  };

  astraOptions = astriOptions // {
    io = mkOption {
      type = submodule { options = IoOptions; };
      default = { };
    };
  };

  userSubmodule = {
    options = komynUserOptions // {
      neim = mkOption {
        type = str;
      };

      trost = mkOption {
        type = enum magnytiud;
      };

      spinyrz = mkOption {
        type = attrs;
        default = { };
      };
    };
  };

  hyraizynOptions = {
    options = {
      metastra = mkOption {
        type = submodule metastraSubmodule;
      };

      astra = mkOption {
        type = submodule { options = astraOptions; };
      };

      exAstriz = mkOption {
        type = attrsOf (submodule { options = astriOptions; });
      };

      users = mkOption {
        type = attrsOf (submodule userSubmodule);
      };

      spinyrz = mkOption {
        type = attrs;
        default = { };
      };
    };
  };

in
{
  options = {
    hyraizyn = mkOption {
      type = submodule hyraizynOptions;
    };

    astraNeim = mkOption {
      type = str;
    };

    metastraNeim = mkOption {
      type = str;
    };

  };

}
