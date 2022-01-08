{ config, pkgs, lib, ... }:

let
  cfg = config.services.udiskie;
  name = "udiskie";

in with lib;

{
  options.services.udiskie = with types; {
    enable = mkEnableOption "Enable udiskie daemon";
  };

  config = mkIf cfg.enable {
    systemd.user.services.udiskie = {
      Unit = {
        Description = "udiskie to automount removable media";
        After = ["default.target"];
      };

      Service = { ExecStart = "${pkgs.udiskie}/bin/udiskie -N"; };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
