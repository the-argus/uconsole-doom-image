{
  description = "Clockwor Pi UConsole image";

  inputs = {
    nixpkgs.url = "github:the-argus/nixpkgs?ref=uconsole-fixes";
    nixos-hardware.url = "github:NixOS/nixos-hardware?rev=0a7b43b5952122a080ad965b3589f17d7dc383d3";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    flake-utils,
    ...
  }: let
    supportedSystems = let
      inherit (flake-utils.lib) system;
    in [
      system.aarch64-linux
      system.x86_64-linux
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        config = {
          # raspberry pi kernel isnt supposed to build on x86_64
          allowUnsupportedSystem = true;
          replaceStdenv = {pkgs, ...}: pkgs.llvmPackages_14.stdenv;
        };
        localSystem.system =
          if system == flake-utils.lib.system.aarch64-linux
          then system
          else (builtins.trace "Compiling with host architecture ${system}. This flake is intended only for use with aarch64-linux. Things may break." system);
        # regardless of host, we are always building for riscv
        crossSystem = {
          system = "riscv64-linux";
          libc = "musl";
          config = "riscv64-unknown-linux-musl";
        };
        overlays = import ./overlays.nix;
      };
    in {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          specialArgs = {
            inherit nixpkgs;
            localConfig = import ./config.nix;
          };
          modules = [
            ./system
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };
      };
    });
}
