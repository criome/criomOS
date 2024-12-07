{ kor, lib, uncheckedCrioSphereProposal }:
let
  inherit (lib) evalModules;

  priMetastriz = uncheckedCrioSphereProposal;

  argzModule = {
    config = {
      _module.args = {
        inherit kor lib priMetastriz;
      };
    };
  };

  metastrizModule = import ./metastrizModule.nix;
  spicizModule = import ./spicizModule.nix;

  ivaliueicyn = evalModules {
    modules = [
      argzModule
      metastrizModule
      spicizModule
    ];
  };

in
{
  inherit (ivaliueicyn.config) spiciz;
  datom = ivaliueicyn.config.Metastriz;
}
