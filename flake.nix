{
  description = "xoebus's dotfiles, as home-manager modules";

  # No inputs: the modules take `pkgs` from whatever home-manager setup
  # imports them, so they always match that machine's nixpkgs.
  outputs = { self }: {
    homeManagerModules = {
      # Config (git, nvim, tmux) plus the editor & shell core tools.
      default = import ./home.nix;
      # Language toolchains, for development machines (not servers).
      dev = import ./dev.nix;
    };
  };
}
