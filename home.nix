# Core dotfiles: what every machine gets.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    git
    jujutsu
    tmux
    ripgrep # telescope live grep
    fd # telescope file finder
    tree-sitter # CLI used by nvim-treesitter to build parsers
    stylua # Lua formatter (conform.nvim)
  ];

  # Link each config folder into ~/.config. These are read-only copies in the
  # Nix store; init.lua keeps lazy.nvim's lockfile in a writable state dir.
  xdg.configFile = {
    "nvim".source = ./nvim;
    "tmux".source = ./tmux;
    "git/config".source = ./git/config;
    "git/ignore".source = ./git/ignore;
  };
}
