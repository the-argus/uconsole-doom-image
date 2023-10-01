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
      overlays = [
        # everything in the packages dir is provided in pkgs.localPackages
        (_: super: rec {
          localPackages = super.callPackage ./packages {};
          glibcLocales = localPackages.dummy;
        })
      ];
    };
  in {
    systemdMinimal = pkgs.systemdMinimal;

    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = hostSystem;
        inherit pkgs;
        specialArgs = import ./config.nix;
        modules = [
          ./system
          nixos-hardware.nixosModules.raspberry-pi-4
          (import "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-riscv64-qemu.nix")
        ];
      };
    };
  };
}
