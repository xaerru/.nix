{ pkgs, inputs, config, ... }:

let colors = config.colorscheme.colors;
in {
  services.picom = {
    enable = true;
    experimentalBackends = true;
    fade = true;
    fadeDelta = 3;
    fadeSteps = [ 4.0e-2 4.0e-2 ];
    menuOpacity = 0.8;
    activeOpacity = 0.95;
    inactiveOpacity = 0.95;
    wintypes = {
      tooltip = {
        fade = true;
        shadow = true;
        opacity = 0.75;
        focus = true;
      };
    };
    opacityRules = [ "92:class_g = 'Alacritty'" ];
    backend = "glx";
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 4;
        background = false;
      };
      blur-background-exclude = [
        "window_type = 'dock'"
        "class_g ~= 'slop'"
        "class_i ~= 'slop'"
        "name ~= 'slop'"
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      vsync = true;
      dbe = false;
      unredir-if-possible = true;
      detect-transient = true;
      detect-client-leader = true;
      transition-length = 100;
      transition-pow-x = 0.1;
      transition-pow-y = 0.1;
      transition-pow-w = 0.1;
      transition-pow-h = 0.1;
      size-transition = true;
      glx-no-stencil = true;
      glx-copy-from-front = false;
      use-damage = true;
      glx-no-rebind-pixmap = true;
    };
  };
}
