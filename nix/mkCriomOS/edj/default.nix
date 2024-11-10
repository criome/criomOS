{ kor, hyraizyn, config, pkgs, lib, uyrld, pkdjz, ... }:
let
  inherit (kor) mkIf optional optionals optionalString optionalAttrs;
  inherit (lib) mkOverride;

  inherit (hyraizyn.astra) typeIs;
  inherit (hyraizyn.astra.spinyrz) saizAtList;

  minPackages = optionals saizAtList.min (with pkgs; [
    adwaita-icon-theme
    nautilus
    libinput
  ]);

  medPackages = with pkgs; [ ];

  maxPackages = with pkgs; [ ];

in
{
  hardware = {
    graphics.enable32Bit = saizAtList.max;
    pulseaudio.enable = false;
  };

  environment = {
    systemPackages = with pkgs; minPackages
      ++ (optionals saizAtList.med medPackages
      ++ (optionals saizAtList.max maxPackages));

    gnome.excludePackages = with pkgs; [
      gnome-software
    ];
  };

  programs = {
    browserpass.enable = saizAtList.max;

    dconf.enable = true;
    droidcam.enable = saizAtList.max;
    evolution.enable = true;
    file-roller.enable = saizAtList.med;

    firejail.enable = saizAtList.med;

    hyprland = {
      enable = typeIs.edjTesting || typeIs.haibrid;
    };

    regreet = {
      enable = !(saizAtList.min);
      settings = {
        GTK = {
          application_prefer_dark_theme = true;
          cursor_theme_name = "Adwaita";
          icon_theme_name = "Adwaita";
          theme_name = "Adwaita";
        };
      };
    };
  };

  services = {
    avahi.enable = saizAtList.min;

    power-profiles-daemon.enable = false;

    dbus.packages = mkIf saizAtList.med [ pkgs.gcr ];

    gnome = {
      at-spi2-core.enable = true;
      core-utilities.enable = true;
      evolution-data-server.enable = true;
      gnome-settings-daemon.enable = true;
    };

    tumbler.enable = saizAtList.med;

    xserver = {
      enable = saizAtList.min;
      excludePackages = with pkgs; [ xorg.xorgserver.out ];
      desktopManager.gnome.enable = saizAtList.med && typeIs.edj;
      displayManager = {
        gdm = {
          enable = saizAtList.min;
          autoSuspend = typeIs.edj;
        };
      };

      windowManager.hypr.enable = typeIs.edjTesting || typeIs.haibrid;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        defaultBrowser = "chromium.desktop";
        defaultMailer = "evolution.desktop";
      in
      {
        defaultApplications."text/html" = defaultBrowser;
        "x-scheme-handler/http" = defaultBrowser;
        "x-scheme-handler/https" = defaultBrowser;
        "x-scheme-handler/ftp" = defaultBrowser;
        "x-scheme-handler/chrome" = defaultBrowser;
        "application/x-extension-htm" = defaultBrowser;
        "application/x-extension-html" = defaultBrowser;
        "application/x-extension-shtml" = defaultBrowser;
        "application/xhtml+xml" = defaultBrowser;
        "application/x-extension-xhtml" = defaultBrowser;
        "application/x-extension-xht" = defaultBrowser;

        "x-scheme-handler/about" = defaultBrowser;
        "x-scheme-handler/unknown" = defaultBrowser;

        "x-scheme-handler/mailto" = defaultMailer;
        "x-scheme-handler/news" = defaultMailer;
        "x-scheme-handler/snews" = defaultMailer;
        "x-scheme-handler/nntp" = defaultMailer;
        "x-scheme-handler/feed" = defaultMailer;
        "message/rfc822" = defaultMailer;
        "application/rss+xml" = defaultMailer;
        "application/x-extension-rss" = defaultMailer;
      };
  };
}
