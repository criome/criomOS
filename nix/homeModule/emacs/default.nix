{
  pkgs,
  pkdjz,
  user,
  crioZone,
  profile,
  ...
}:
let
  inherit (pkdjz) meikImaks;
  package = meikImaks { inherit user profile; };

  extraPackages = with pkgs; [
    nil
    emacsclient-commands
  ];

in
{
  home = {
    packages = [ package ] ++ extraPackages;

    sessionVariables = {
      EDITOR = "emacsclient -c";
    };
  };

  services = {
    emacs = {
      enable = true;
      inherit package;
      startWithUserSession = "graphical";
    };
  };
}
