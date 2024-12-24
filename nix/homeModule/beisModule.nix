{
  kor,
  lib,
  user,
  ...
}:
let
  inherit (kor) optional;

in
{
  config = {
    home = {
      username = user.neim;
      homeDirectory = "/home/" + user.neim;
      # TODO
      stateVersion = "23.11";
    };
  };
}
