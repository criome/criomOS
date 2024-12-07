{ kor, lib, hyraizyn, ... }:
let
  inherit (kor) concatMapAttrs;
  inherit (lib) mkOverride optional optionals;
  inherit (hyraizyn) astra exAstriz;
  inherit (builtins) concatStringsSep;

  mkCriomeHostEntries = neim: astri:
    let
      inherit (astri) criomOSNeim neksysIp yggAddress;
      inherit (astri.spinyrz) izNiksKac nixCacheDomain;

      mkPreNeksysHost = linkLocalIP: {
        name = linkLocalIP;
        value = [ ("wg." + criomOSNeim) ];
      };

      neksysHost = {
        name = neksysIp;
        value = [ criomOSNeim ];
      };

      preNeksysHosts = map mkPreNeksysHost astri.linkLocalIPs;

      neksysHosts = optionals (neksysIp != null)
        ([ neksysHost ] ++ preNeksysHosts);

      yggdrasilHost = optional (yggAddress != null) {
        name = yggAddress;
        value = [ criomOSNeim ] ++
          (optional izNiksKac nixCacheDomain);
      };

    in
    yggdrasilHost ++ neksysHosts;

in
{
  imports = [
    ./unbound.nix
    ./yggdrasil.nix
  ];

  networking = {
    hostName = astra.neim;
    dhcpcd.extraConfig = "noipv4ll";
    nameservers = [ "::1" "127.0.0.1" ];
    hosts = concatMapAttrs mkCriomeHostEntries exAstriz;
  };

  services = {
    nscd.enable = false;
  };

  system.nssModules = mkOverride 0 [ ];
}
