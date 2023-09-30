{
  pkgs,
  lib,
  ...
}: {
  # enable nix flakes
  nix = {
    package = lib.mkDefault pkgs.nixVersions.stable;
    # package =  pkgs.nixVersions.nix_2_7;
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-old";
    # };
    settings = {
      extra-experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://cache.nixos.org/"
        "https://cache.allvm.org/"
      ];
      trusted-public-keys = [
        "gravity.cs.illinois.edu-1:yymmNS/WMf0iTj2NnD0nrVV8cBOXM9ivAkEdO1Lro3U="
      ];
      auto-optimise-store = true;
    };
  };
}
