{
  config,
  kor,
  hyraizyn,
  pkgs,
  lib,
  uyrld,
  ...
}:
let
  l = lib // builtins;
  inherit (kor) mapAttrsToList eksportJSON;
  inherit (lib)
    concatStringsSep
    mkOverride
    optional
    mkIf
    optionalString
    optionalAttrs
    ;
  inherit (pkgs) mksh writeScript gnupg;
  inherit (hyraizyn) astra exAstriz;
  inherit (hyraizyn.astra) typeIs;
  inherit (hyraizyn.astra.spinyrz) tcipIzIntel saizAtList iuzColemak;

  # TODO
  hasAudioOutput = true;
  hasVideoOutput = true;
  hasAcceleratedVideoOutput = true;

  jsonHyraizynFail = eksportJSON "hyraizyn.json" hyraizyn;

  criomOSShell = mksh + mksh.shellPath;

  mkAstriKnownHost =
    n: astri:
    concatStringsSep " " [
      astri.criomOSNeim
      astri.eseseitc
    ];

  sshKnownHosts = concatStringsSep "\n" (mapAttrsToList mkAstriKnownHost exAstriz);

in
{
  boot = {
    kernelParams = [ "consoleblank=300" ];

    kernelPackages = pkgs.linuxPackages_latest;

    supportedFilesystems = mkOverride 50 (
      [
        "xfs"
        "btrfs"
      ]
      ++ (optional saizAtList.min "exfat")
    );
  };

  documentation = {
    enable = !config.boot.isContainer;
    nixos.enable = !config.boot.isContainer;
  };

  environment = {
    binsh = criomOSShell;
    shells = [ "/run/current-system/sw${mksh.shellPath}" ];

    etc = {
      "systemd/user-environment-generators/ssh-sock.sh".source = writeScript "user-ssh-sock.sh" ''
        #!${pkgs.mksh}/bin/mksh
          echo "SSH_AUTH_SOCK=$(${gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"
      '';
      "ssh/ssh_known_hosts".text = sshKnownHosts;
      "hyraizyn.json" = {
        source = jsonHyraizynFail;
        mode = "0600";
      };
    };

    systemPackages = with pkgs; [
      uyrld.skrips.root
      tcpdump
      librist
      openssh
    ];

    interactiveShellInit = optionalString iuzColemak "stty -ixon";
    sessionVariables = (
      optionalAttrs iuzColemak {
        XKB_DEFAULT_LAYOUT = "us";
        XKB_DEFAULT_VARIANT = "colemak";
      }
    );
  };

  # Overlays are bad - force them off
  nixpkgs.overlays = mkOverride 0 [ ];

  networking.networkmanager = {
    enable = saizAtList.min && !typeIs.router;
  };

  programs = {
    zsh.enable = true;
    adb.enable = saizAtList.med;
    light.enable = hasVideoOutput;
  };

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      ports = [ 22 ];
    };

    pipewire = mkIf hasAudioOutput {
      enable = true;
      alsa.enable = true;
      jack.enable = false;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    udev = {
      extraRules = ''
        # What is this for?
        ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", GROUP="dialout", MODE="0660"
      '';
    };

  };

  system.stateVersion = "24.05";

  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    groups.dialout = { };
  };
}
