{
  localConfig,
  lib,
  ...
}: let
  inherit (localConfig) hostname;
  answer = bool:
    if bool
    then "y"
    else "n";
in
  builtins.toFile "kernelconfig" ''''
