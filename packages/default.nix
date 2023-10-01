{callPackage, ...}: {
  issue = callPackage ./issue {};
  dummy = callPackage ./dummy {};
  kernelconfig = callPackage ./kernelconfig {};
}
