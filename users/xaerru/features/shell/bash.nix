{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      v = "nvim";
      c = "clear";
      cat = "bat";
      getip = "curl ifconfig.me";
      cdc = "cd && clear";
      lg = "lazygit";
      ls = "exa -l --color=always --group-directories-first";
      la = "exa -al --color=always --group-directories-first";
      "l." = "exa -a | rg '^\.'";
      ".." = "cd ..";
    };
  };
}
