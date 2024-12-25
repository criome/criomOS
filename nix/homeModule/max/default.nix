{
  kor,
  pkgs,
  user,
  pkdjz,
  ...
}:
let
  inherit (kor) optionals;
  inherit (user.spinyrz) izNiksDev izSemaDev saizAtList;

  niksDevPackages = with pkgs; [ pandoc ];

  semaDevPackages = with pkgs; [
    krita
    calibre
    virt-manager
    gimp
  ];

in
kor.mkIf saizAtList.max {
  home = {
    packages =
      with pkgs;
      [
        # freecad # broken
        wineWowPackages.waylandFull
        whatsapp-for-linux
      ]
      ++ (optionals izNiksDev niksDevPackages)
      ++ (optionals izSemaDev semaDevPackages);
  };

  programs = {
    chromium = {
      enable = true;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      ];
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
        wlrobs
        pkdjz.obs-ndi
        obs-pipewire-audio-capture
        # advanced-scene-switcher # TODO broken.build
        obs-move-transition
        obs-vaapi
        waveform
      ];
    };

  };

  services = {
    easyeffects = {
      enable = true;
    };
  };
}
