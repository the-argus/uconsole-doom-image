{
  description = "Clockwor Pi UConsole image";

  inputs = {
    nixpkgs.url = "github:the-argus/nixpkgs?ref=uconsole-fixes";
    nixos-hardware.url = "github:NixOS/nixos-hardware?rev=0a7b43b5952122a080ad965b3589f17d7dc383d3";
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    ...
  }: let
    hostSystem = "x86_64-linux";
    targetSystem = "riscv64-linux";
    pkgs = import nixpkgs {
      config = {
        # raspberry pi kernel isnt supposed to build on x86_64
        allowUnsupportedSystem = true;
        replaceStdenv = {pkgs, ...}: pkgs.llvmPackages_14.stdenv;
      };
      localSystem = {
        system = hostSystem;
      };
      crossSystem = {
        system = targetSystem;
        libc = "musl";
        config = "riscv64-unknown-linux-musl";
      };
      overlays = import ./overlays.nix;
    };
  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = hostSystem;
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
  };
}
