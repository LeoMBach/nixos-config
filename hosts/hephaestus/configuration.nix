{ config, pkgs, lib, ... }:

let
  settings = import ../../secrets/hephaestus/settings.nix;
in
{
  imports = [
    ../../../hardware-configuration.nix

    ./rclone-mounts.nix
    ./services
    ../../nix
    ../../pkgs
    ../../virtualisation/docker.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  environment.systemPackages = with pkgs; [ figlet transcrypt ];

  networking = {
    hostName = "hephaestus";
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  services.openssh.enable = true;

  security = {
    sudo.wheelNeedsPassword = false;
    acme = {
      acceptTerms = true;
      certs = {
        "${settings.domain}".email = "${settings.acmeEmail}";
      };
    };
  };

  programs.zsh.loginShellInit = "figlet Hephaestus";

  users = {
    mutableUsers = true;
    users = {
      heph = {
        uid = 1000;
        shell = pkgs.zsh;
        home = "/home/heph";
        isNormalUser = true;
        initialPassword = "letmein";
        extraGroups = [ "docker" "wheel" ];
        openssh.authorizedKeys.keyFiles = [ ./keys/hermes.pub ];
      };
    };
  };

  system.stateVersion = "20.09";
}
