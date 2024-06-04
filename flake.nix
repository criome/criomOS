{
  description = "CriomOS";

  inputs = {
    hob.url = "github:criome/hob/15Gemini5918AM-rename";

    mkWebpage = { url = "path:./mkWebpage"; flake = false; };
    kor = { url = "path:./nix/kor"; flake = false; };
    mkPkgs = { url = "path:./nix/mkPkgs"; flake = false; };
    mkDatom = { url = "path:./nix/mkDatom"; flake = false; };
    mkUyrld = { url = "path:./nix/mkUyrld"; flake = false; };
    mkCrioSphere = { flake = false; url = "path:./nix/mkCrioSphere"; };
    mkCrioZones = { flake = false; url = "path:./nix/mkCrioZones"; };
    mkCriomOS = { flake = false; url = "path:./nix/mkCriomOS"; };
    pkdjz = { flake = false; url = "path:./nix/pkdjz"; };
    homeModule = { flake = false; url = "path:./nix/homeModule"; };
    neksysNames = { flake = false; url = "path:./neksysNames.nix"; };
    tests = { url = "path:./nix/tests"; flake = false; };
    files = { url = "path:./nix/files"; flake = false; };
    AskiCoreNiks = { url = "path:./AskiCoreNiks"; flake = false; };
    AskiNiks = { url = "path:./AskiNiks"; flake = false; };
    AskiDefaultBuilder = { url = "path:./AskiDefaultBuilder"; flake = false; };
  };

  outputs = inputs@{ self, ... }:
    let
      criomeOSRev =
        let shortHash = kor.cortHacString self.narHash;
        in self.shortRev or shortHash;

      localHobSources = {
        inherit (inputs) AskiCoreNiks AskiNiks AskiDefaultBuilder
          xdg-desktop-portal-hyprland mkWebpage;
        pkdjz = { HobUyrldz = import inputs.pkdjz; };
      };

      importInput = name: value:
        import value;

      hob = inputs.hob.value // localHobSources;

      inherit (hob) flake-utils emacs-overlay nixpkgs lib;

      imports = mapAttrs importInput {
        inherit (inputs) kor mkPkgs mkCrioSphere mkCrioZones mkCriomOS
          mkHomeConfig neksysNames mkUyrld homeModule files;
      };

      inherit (imports) kor neksysNames mkPkgs homeModule mkCriomOS mkUyrld;

      mkPkgsAndUyrldFromSystem = system:
        let
          pkgs =
            let
              overlays = [ emacs-overlay.overlay ];
            in
            mkPkgs { inherit nixpkgs lib system overlays; };
          uyrld = mkUyrld { inherit lib pkgs system hob imports; };
        in
        { inherit pkgs uyrld; };

      perSystemPkgsAndUyrld = eachDefaultSystem mkPkgsAndUyrldFromSystem;

      mkPkgsAndUyrld = system:
        mapAttrs (name: value: value.${system}) perSystemPkgsAndUyrld;

      mkDatom = import inputs.mkDatom { inherit kor lib; };
      mkCriomeDatom = import inputs.mkCriomeDatom { inherit kor lib mkDatom; };

      inherit (builtins) fold attrNames mapAttrs filterAttrs;
      inherit (kor) mkLamdy arkSistymMap genAttrs;
      inherit (flake-utils.lib) eachDefaultSystem;

      generateCrioSphereProposalFromName = name:
        let
          subCriomeConfig = hob."${name}".NeksysProposal or { };
          explicitNodes = subCriomeConfig.astriz or { };
          implicitNodes = import ./implicitNodes.nix;
          allNodes = explicitNodes // implicitNodes;
        in
        subCriomeConfig // { astriz = allNodes; };

      uncheckedCrioSphereProposal = genAttrs
        neksysNames
        generateCrioSphereProposalFromName;

      mkNeksysDerivations = priNeksysNeim: crioZone:
        let
          inherit (crioZone) users;
          inherit (crioZone.astra.mycin) ark;
          system = arkSistymMap.${ark};
          pkgsAndUyrld = mkPkgsAndUyrld system;
          inherit (pkgsAndUyrld) pkgs uyrld;
          hyraizyn = crioZone;

          userProfiles = {
            light = { dark = false; };
            dark = { dark = true; };
          };

          mkUserHomz = userNeim: user:
            let
              inherit (uyrld) pkdjz;

              mkProfileHom = profileName: profile:
                let
                  modules = [ homeModule ];
                  extraSpecialArgs =
                    { inherit kor pkdjz uyrld hyraizyn user profile; };
                  evalHomeManager = hob.home-manager.lib.homeManagerConfiguration;
                  evaluation = evalHomeManager
                    { inherit modules extraSpecialArgs pkgs; };
                in
                evaluation.config.home.activationPackage;
            in
            mapAttrs mkProfileHom userProfiles;

          mkUserImaks = userNeim: user:
            let
              inherit (uyrld.pkdjz) meikImaks;
              mkProfileImaks = profileName: profile:
                meikImaks { inherit user profile; };
            in
            mapAttrs mkProfileImaks userProfiles;

        in
        {
          os = mkCriomOS
            { inherit criomeOSRev kor uyrld hyraizyn homeModule hob; };
          hom = mapAttrs mkUserHomz users;
          imaks = mapAttrs mkUserImaks users;
        };

      mkEachCrioZoneDerivations = crioZones:
        let
          mkNeksysDerivationIndex = neksysNeim: neksysPrineksysIndeks:
            mapAttrs mkNeksysDerivations neksysPrineksysIndeks;
        in
        mapAttrs mkNeksysDerivationIndex crioZones;

      mkNixApiOutputsPerSystem = system:
        let
          pkgsAndUyrld = mkPkgsAndUyrld system;
          inherit (pkgsAndUyrld) pkgs uyrld;
          inherit (pkgs) symlinkJoin linkFarm;

          inherit (uyrld.pkdjz) shen-ecl-bootstrap;
          shen = shen-ecl-bootstrap;

          devShell = pkgs.mkShell {
            inputsFrom = [ ];
            CRIOMOSBOOTFILE = self + /boot.shen;
            buildInputs = [ shen ];
          };

          mkHobOutput = name: src:
            symlinkJoin { inherit name; paths = [ src.outPath ]; };

          hobOutputs = mapAttrs mkHobOutput hob;

          mkSpokFarmEntry = name: spok:
            { inherit name; path = spok.outPath; };

          allMeinHobOutputs = linkFarm "hob"
            (kor.mapAttrsToList mkSpokFarmEntry hobOutputs);

          packages = uyrld // {
            inherit pkgs;
            hob = hobOutputs;
            fullHob = allMeinHobOutputs;
          };

          tests = import inputs.tests { inherit lib mkDatom; };

        in
        { inherit tests packages devShell; };

      perSystemAllOutputs = eachDefaultSystem mkNixApiOutputsPerSystem;

      proposedCrioSphere = imports.mkCrioSphere { inherit uncheckedCrioSphereProposal kor lib; };
      proposedCrioZones = imports.mkCrioZones { inherit kor lib proposedCrioSphere; };

    in
    perSystemAllOutputs // {
      crioZones = mkEachCrioZoneDerivations proposedCrioZones;
    };
}
