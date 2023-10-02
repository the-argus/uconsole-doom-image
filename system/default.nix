{
  pkgs,
  lib,
  localConfig,
  ...
}: let
  inherit (localConfig) shellSettings hasNetwork username initialPassword;
  usesZsh = shellSettings.using == shellSettings.shells.zsh;
  usesBash = shellSettings.using == shellSettings.shells.bash;
in {
  imports =
    [
      ./hardware.nix
      ./solokey.nix
      ./bling.nix
      ./packages.nix
      ./minimize.nix
      ./nix.nix
      ./sd-image.nix
    ]
    ++ (lib.optionals usesZsh [./zsh.nix]);

  system.stateVersion = "23.05";
  time.timeZone = lib.mkDefault "America/New_York";

  # console
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
  };

  users.users.${username} = {
    shell =
      if usesZsh
      then pkgs.zsh
      else if usesBash
      then pkgs.bash
      else abort "Invalid shell";
    inherit initialPassword;
    isNormalUser = true;
    extraGroups =
      [
        "wheel"
        "video"
        "audio"
        "jackaudio"
        "plugdev"
      ]
      ++ (lib.optionals hasNetwork [
        "systemd-network"
        "networkmanager"
      ]);
  };
}
