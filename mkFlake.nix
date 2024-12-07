{ inputs, ... }:

{
  imports = with inputs; [ ];

  proposedCrioSphere = localSources.mkCrioSphere { inherit uncheckedCrioSphereProposal kor lib; };
  proposedCrioZones = localSources.mkCrioZones { inherit kor lib proposedCrioSphere; };

  perSystem = { ... }: { };
}
