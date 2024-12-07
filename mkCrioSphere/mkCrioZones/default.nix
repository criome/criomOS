{ kor, lib, proposedCrioSphere }:
let
  inherit (builtins) mapAttrs;
  inherit (lib) evalModules;

  metastriz = proposedCrioSphere;

  hyraizynOptions = import ./hyraizynOptions.nix;
  mkHyraizynModule = import ./mkHyraizynModule.nix;

  mkCrioZone = neksysNeim: priNeksysNeim:
    let
      astraNeim = priNeksysNeim;
      metastraNeim = neksysNeim;

      argzModule = {
        config = {
          inherit astraNeim metastraNeim;
          _module.args = {
            inherit kor lib;
            Metastriz = metastriz.datom;
            metastrizSpiciz = metastriz.spiciz;
          };
        };
      };

      ivaliueicyn = evalModules {
        modules = [
          argzModule
          hyraizynOptions
          mkHyraizynModule
        ];
      };

      crioZone = ivaliueicyn.config.hyraizyn;

    in
    crioZone;

  mkNeksysCrioZones = neksysNeim: neksys:
    # let priNeksysNeimz = attrNames neksys.astriz; in
    mapAttrs (pnn: pn: mkCrioZone neksysNeim pnn) neksys.astriz;

  ryzylt = mapAttrs mkNeksysCrioZones proposedCrioSphere.datom;

in
ryzylt
