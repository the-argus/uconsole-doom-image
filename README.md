# uconsole-doom-image

A nix flake to cross compile an image for my RISCV clockwork pi uconsole.

## Usage

```bash
# on x86_64-linux
nix build .#nixosConfigurations.x86_64-linux.default.config.system.build.sdImage

# on aarch
nix build .#nixosConfigurations.aarch64-linux.default.config.system.build.sdImage
```
