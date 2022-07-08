{ pkgs, inputs, config, ... }:

let colors = config.colorscheme.colors;
in {
  programs.zathura = {
    enable = true;
    options = {
      notification-error-bg = "#${colors.base08}";
      notification-error-fg = "#${colors.base05}";
      notification-warning-bg = "#${colors.base0A}";
      notification-warning-fg = "#${colors.base02}";
      notification-bg = "#${colors.base00}";
      notification-fg = "#${colors.base05}";
      completion-bg = "#${colors.base00}";
      completion-fg = "#${colors.base0D}";
      completion-group-bg = "#${colors.base00}";
      completion-group-fg = "#${colors.base0D}";
      completion-highlight-bg = "#${colors.base02}";
      completion-highlight-fg = "#${colors.base05}";
      index-bg = "#${colors.base00}";
      index-fg = "#${colors.base05}";
      index-active-bg = "#${colors.base02}";
      index-active-fg = "#${colors.base05}";
      inputbar-bg = "#${colors.base00}";
      inputbar-fg = "#${colors.base05}";
      statusbar-bg = "#${colors.base00}";
      statusbar-fg = "#${colors.base05}";
      highlight-color = "#${colors.base0A}";
      highlight-active-color = "#${colors.base0E}";
      default-bg = "#${colors.base00}";
      default-fg = "#${colors.base05}";
      render-loading-fg = "#${colors.base00}";
      render-loading-bg = "#${colors.base05}";
      recolor-lightcolor = "#${colors.base00}";
      recolor-darkcolor = "#${colors.base05}";
      render-loading = true;
      window-title-basename = true;
      selection-clipboard = "clipboard";
      recolor = true;
      pages-per-row = 2;
      scroll-page-aware = true;
      scroll-full-overlap = "0.01";
      scroll-step = 100;
      zoom-min = 10;
      guioptions = "";
    };
    extraConfig = ''
      map r reload
      map p print
      map i recolor
      map J zoom out
      map K zoom in
      map R rotate
      map H feedkeys ":exec sh -c \"cat ~/.local/share/zathura/history | grep -Po '\[\K[^\]]*' | dmenu | xargs zathura\""
    '';
  };
}
