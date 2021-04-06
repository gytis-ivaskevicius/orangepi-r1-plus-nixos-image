{ pkgs, stdenv ? pkgs.stdenv, lib ? pkgs.lib, kernel ? pkgs.kernel, ethSrc}:

stdenv.mkDerivation rec {
  pname = "r8125";
  # On update please verify (using `diff -r`) that the source matches the
  # realtek version.
  version = "9.004.01";

  # This is a mirror. The original website[1] doesn't allow non-interactive
  # downloads, instead emailing you a download link.
  # [1] https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
  src = ethSrc;

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    makeFlagsArray+=("EXTRA_CFLAGS += -DRTL8152_S5_WOL")
  '';
  #preBuild = ''
  #  makeFlagsArray+=("-C${kernel.dev}/lib/modules/${kernel.modDirVersion}/build")
  #  makeFlagsArray+=("M=$PWD/src")
  #  #makeFlagsArray+=("modules")
  #  substituteInPlace src/Makefile --replace "BASEDIR :=" "BASEDIR ?="
  #  substituteInPlace src/Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
  #'';

  makeFlags = [
    #"BASEDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  buildFlags = [ "modules" ];


  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents '{}' ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f '{}' \;
  '';

}
