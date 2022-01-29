{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    disableConfirmationPrompt = true;
    escapeTime = 150;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      pain-control
      fzf-tmux-url
      {
        plugin = battery;
        extraConfig = ''
          set -g status-right '[#(tmux-mem-cpu-load)][#{battery_percentage}][%d-%m:%w][%H:%M][#H]'
          set -g status-right-length '150'
        '';
      }
    ];
    extraConfig = builtins.readFile ../../config/tmux.conf;
  };
}
