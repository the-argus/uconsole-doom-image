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
        packageName = "linux_rpi4";
        src = super.linuxKernel.kernels.${packageName}.src;
        version = super.linuxKernel.kernels.${packageName}.version;
        versionPrefix = "6.1.21";
      in
        override super.linuxKernel.kernels {
          ${packageName} =
            (super.linuxKernel.manualConfig {
              stdenv = super.gccStdenv;
              inherit src version;
              modDirVersion = "${
                if super.lib.strings.hasPrefix versionPrefix version
                then versionPrefix
                else abort "versionPrefix ${versionPrefix} not accurate to version ${version}. You have probably updated and need to modify the hardcoded value of versionPrefix in this file."
              }-${super.lib.strings.toUpper super.localConfig.hostname}";
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
