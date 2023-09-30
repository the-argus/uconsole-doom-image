# a file with settings meant to reduce compilation times and image size
{...}: {
  services.dbus.implementation = "broker";

  documentation = {
    info.enable = false;
    dev.enable = false;
    nixos.enable = false;
  };
}
