{ config, pkgs, lib, ... }:

{
  imports = [
    ../../../hardware-configuration.nix

    ./pkgs/idea-ultimate.nix

    ../../common/grub-efi.nix
    ../../common/laptop.nix
    ../../common/ssd.nix
    ../../common/user.nix
    ../../nix
    ../../pkgs
    ../../pkgs/plasma5.nix
    ../../virtualisation/docker.nix
    ../../modules/vscode-liveshare.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_9;
    kernelParams = [ "i915.enable_fbc=1" ]; # https://wiki.archlinux.org/index.php/intel_graphics#Framebuffer_compression_(enable_fbc)
    kernelModules = [
      "kvm-amd"
      "kvm-intel"
    ];

    loader.grub.enableCryptodisk = true;

    initrd = {
      luks.devices = {
        ssd = {
          device = "/dev/disk/by-label/cryptlvm";
          preLVM = true;
          allowDiscards = true;
        };
      };

      # Improve encryption performance
      availableKernelModules = [
        "aes_x86_64"
        "aesni_intel"
        "cryptd"
      ];
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;

    opengl.extraPackages = [ pkgs.vaapiIntel ];

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };
  };

  networking = {
    hostName = "ZAGALW-LMA-HP";
    networkmanager.enable = true;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp2s0.useDHCP = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "Europe/Zagreb";

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    android-studio
    ansible
    ansible-lint
    ant
    chromium
    cloudfoundry-cli
    dbeaver
    dive
    eclipses.eclipse-java
    firefox
    freerdp
    fuse3
    fzf
    gimp
    gitAndTools.gitflow
    glib-networking # Needed by Eclipse Liberty Tools plugin
    gradle
    home-manager
    inkscape
    jd-gui
    lazygit
    libreoffice
    liquibase
    maven
    meld
    networkmanager-openconnect
    nodePackages.npm
    nodejs
    openconnect
    postman
    qemu
    rclone
    remmina
    scrcpy
    shellcheck
    signal-desktop
    skype
    soapui
    sshfs
    sshuttle
    teams
    virt-manager
    vlc
    vscode
    wireshark
    yarn
    youtube-dl
  ];

  services.xserver = {
    displayManager = {
      autoLogin.user = "leo";
      defaultSession = "plasma5";
    };
    videoDrivers = [ "intel" ];
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
    };

    java = {
      enable = true;
      package = pkgs.jdk14;
    };

    ssh = {
      startAgent = true;
      extraConfig = builtins.readFile ../../secrets/work/ssh/config;
    };

    usbtop.enable = true;
  };

  system.stateVersion = "20.09";
}
