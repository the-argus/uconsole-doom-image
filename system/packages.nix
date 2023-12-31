{
  pkgs,
  localConfig,
  lib,
  ...
}: let
  inherit (localConfig) hasNetwork;
in {
  environment.systemPackages = with pkgs;
    [
      # always good to have
      polkit

      # tui applications
      htop

      # util
      file
      usbutils
      alsa-utils
      killall
    ]
    ++ (lib.optionals hasNetwork [
      git
      wget
      curl
      pciutils
      inetutils
    ]);
}
