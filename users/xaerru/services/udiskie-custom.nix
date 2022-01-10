{ config, pkgs, lib, ... }:

let
  cfg = config.services.udiskie-custom;
  name = "udiskie";

in with lib;

{
  options.services.udiskie-custom = with types; {
    enable = mkEnableOption "Enable udiskie daemon";
  };

  config = mkIf cfg.enable {
    systemd.user.services.udiskie-custom = {
      Unit = {
        Description = "udiskie to automount removable media";
      };

      Service = { ExecStart = "${pkgs.udiskie}/bin/udiskie -N"; };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
