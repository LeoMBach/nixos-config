{ config, lib, ... }:

let
  globalConf = import ../../../secrets/dionysus/global-config.nix;
in
{
  services.borgbackup.jobs = {
    services = {
      paths = [
        "/var/lib/gitea"
        "/var/lib/jellyfin"
        "/var/lib/nextcloud"
        "/var/backup/postgresql"
      ];

      repo = "/var/backup/borg";
      doInit = true;
      extraCreateArgs = "--stats";

      startAt = "*-*-* 03:00:00"; # Should happen after postgres dump
      prune.keep = {
        daily = 7;
        weekly = 4;
        monthly = 6;
        yearly = 1;
      };

      compression = "auto,zstd,19";

      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ../../../secrets/dionysus/borg/services-pass.txt";
      };

    };
  };
}
