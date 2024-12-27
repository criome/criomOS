{ lib, mkDatom }:

{
  datom = mkDatom { };
  librist = import ./librist.nix;
}
