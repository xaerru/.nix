{ config, pkgs, lib, ... }:

let
  cfg = config.services.udiskie-custom;
  yamlFormat = pkgs.formats.yaml { };

in with lib;

{
  options.services.udiskie-custom = with types; {
    enable = mkEnableOption "Enable udiskie daemon";
    settings = mkOption {
      type = yamlFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.udiskie ];
    xdg.configFile."udiskie/config.yml" = mkIf (cfg.settings != { }) {
      source = yamlFormat.generate "udiskie-config" cfg.settings;
    };
    # Not to be run as a systemd service
    # TODO: figure out a way to add these to .xinitrc declaratively
    #systemd.user.services.udiskie-custom = {
    #  Unit = {
    #    Description = "udiskie to automount removable media";
    #  };

    #  Service = {
    #    ExecStart = "${pkgs.udiskie}/bin/udiskie"; 
    # };

    #  Install.WantedBy = [ "default.target" ];
    #};
  };
}
