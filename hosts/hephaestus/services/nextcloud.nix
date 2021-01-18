{ config, pkgs, lib, ... }:

let
  settings = import ../../../secrets/hephaestus/settings.nix;
in
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud20;
    hostName = settings.nextcloud.domain;
    https = true;
    autoUpdateApps.enable = true;
    config = {
      adminuser = "admin";
      adminpass = "admin";

      dbtype = "pgsql";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbpass = "nextcloud";
    };
  };

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
}
