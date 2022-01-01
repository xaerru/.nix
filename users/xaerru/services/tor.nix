{ config, pkgs, lib, ... }:

let
  cfg = config.services.tor;
  name = "tor";

in with lib;

{
  options.services.tor = with types; {
    enable = mkEnableOption "Enable tor service";
  };

  config = mkIf cfg.enable {
    systemd.user.services.tor = {
      Unit = {
        Description = "Tor service";
        After = ["network.target"];
        RefuseManualStart = true;
      };

      Service = { ExecStart = "${pkgs.tor}/bin/tor"; };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
