{
  username = "doomguy";
  hostname = "doombox";
  initialPassword = "changeme";

  hasNetwork = false;

  shellSettings = rec {
    shells = {
      zsh = "zsh";
      bash = "bash";
    };

    using = shells.zsh;
  };

  archname = "tigerlake";
}
