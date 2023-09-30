{
  archname,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # nix.settings.system-features = [
  #   "nixos-test"
  #   "benchmark"
  #   "big-parallel"
  #   "kvm"
  #   "gccarch-${archname}"
  # ];

  # boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
  # boot.initrd.kernelModules = [];
  # boot.kernelModules = [];
  # boot.extraModulePackages = [];

  # fileSystems."/" = {
  #   device = "/dev/disk/by-label/NIXROOT";
  #   fsType = "ext4";
  # };

  # fileSystems."/home" = {
  #   device = "/dev/disk/by-label/NIXHOME";
  #   fsType = "ext4";
  # };

  # swapDevices = [{device = "/dev/disk/by-label/SWAP";}];

  # choose between "ondemand", "powersave", and "performance"
  powerManagement.cpuFreqGovernor = "performance";
}
