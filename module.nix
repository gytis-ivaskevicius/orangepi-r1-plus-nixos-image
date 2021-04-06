{ pkgs, stdenv ? pkgs.stdenv, lib ? pkgs.lib, kernel ? pkgs.linuxPackages_latest.kernel, ethSrc }:

stdenv.mkDerivation rec {
  pname = "r8152";
  version = "14";
  src = ethSrc;

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    makeFlagsArray+=("EXTRA_CFLAGS += -DRTL8152_S5_WOL")
  '';

  makeFlags = [
    #"BASEDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    #"KERNELRELEASE=${kernel.modDirVersion}"
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  buildFlags = [ "modules" ];


  enableParallelBuilding = true;

  #installPhase = "find .";
  installPhase = let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/r8152"; in
    ''
      mkdir -p ${modDestDir}
      find . -name '*.ko' -exec cp --parents '{}' ${modDestDir} \;
      find ${modDestDir} -name '*.ko' -exec xz -f '{}' \;
    '';

}
