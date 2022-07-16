{ pkgs, inputs, ... }:

with inputs.nix-colors.lib-contrib { inherit pkgs; };

rec {
  gtk = {
    enable = true;
    theme = {
      name = "default-dark";
      package = gtkThemeFromScheme {
        scheme = inputs.nix-colors.colorSchemes.default-dark;
      };
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
  services.xsettingsd = {
    enable = true;
    settings = { "Net/ThemeName" = "${gtk.theme.name}"; };
  };
  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Wallpaper service";
      Wants = "wallpaper.timer";
    };
    Service = {
      Type = "oneshot";
      ExecStart =
        "/home/xaerru/.nix/bin/wallpaper.sh";
    };
    Install.WantedBy = [ "multi-user.target" ];
  };
  systemd.user.timers.wallpaper = {
    Unit = {
      Description = "Wallpaper service";
      Requires = "wallpaper.service";
    };
    Timer = {
      OnBootSec = "1hour";
      OnCalendar = "hourly";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
