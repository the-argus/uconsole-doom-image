# Anything optional that just looks nice
{pkgs, ...}: {
  environment.etc.issue.source = pkgs.localPackages.issue;

  environment.systemPackages = with pkgs; [
    neofetch
  ];
}
