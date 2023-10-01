[
  # provide global configuration values in the pkgs set
  (_: _: {
    localConfig = import ./config.nix;
  })

  # everything in the packages dir is provided in pkgs.localPackages
  (_: super: {
    localPackages = super.callPackage ./packages {};
  })

  # misc fixes, mostly for musl
  (_: super: {
    glibcLocales = super.localPackages.dummy;
    reiserfsprogs = abort "reiserfsprogs is broken, it uses gcc extensions";
  })

  # override linux kernel
  (_: super: let
    override = super.lib.attrsets.recursiveUpdate;
  in rec {
    linuxKernel = override super.linuxKernel {
      kernels = let
        packageName = "linux_xanmod_latest";
        src = super.linuxKernel.kernels.${packageName}.src;
        version = super.linuxKernel.kernels.${packageName}.version;
      in
        override super.linuxKernel.kernels {
          ${packageName} =
            (super.linuxKernel.manualConfig {
              stdenv = super.gccStdenv;
              inherit src version;
              modDirVersion = "${version}-${super.lib.strings.toUpper super.localConfig.hostname}-xanmod1";
              inherit (super) lib;
              configfile = super.localPackages.kernelconfig;
              allowImportFromDerivation = true;
            })
            .overrideAttrs (oa: {
              nativeBuildInputs = (oa.nativeBuildInputs or []) ++ [super.lz4];
            });
        };
    };
  })
]
