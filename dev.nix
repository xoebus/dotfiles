# Language toolchains and LSP servers, for development machines.
# (Mirrors the Brewfile; not imported on servers like tungsten.)
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    go
    gopls
    gotools # includes goimports
    gofumpt
    nodejs # for JSON/YAML/TS language servers
    zig
    zls
    rustup
  ];
}
