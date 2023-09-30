{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    pam_u2f
  ];

  # PAM authentication for yubikey/solokey
  # line to add with mkOverride: "auth       required   pam_u2f.so"
  services.udev.extraRules = ''    ACTION!="add|change", GOTO="solokeys_end"
    # SoloKeys rule

    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a2ca", TAG+="uaccess"

    LABEL="solokeys_end"'';

  # line that might be necessary to add:
  # @include common-auth
  security.pam.u2f.enable = true;
  security.pam.services.login.text = lib.mkDefault (lib.mkBefore ''
    auth sufficient pam_u2f.so
  '');
  security.pam.services.sudo.text = lib.mkDefault (lib.mkBefore ''
    auth sufficient pam_u2f.so
  '');
}
