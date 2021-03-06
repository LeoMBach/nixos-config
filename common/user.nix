{ config, pkgs, ... }:

{
  users = {
    mutableUsers = true;
    users.leo = {
      uid = 1000;
      shell = pkgs.zsh;
      home = "/home/leo";
      isNormalUser = true;
      initialPassword = "letmein";
      extraGroups = [ "adbusers" "disk" "networkmanager" "plugdev" "wheel" ];
    };
  };
}
