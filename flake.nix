{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;

    aarch-images = {
      url = "github:Mic92/nixos-aarch64-images";
      flake = false;
    };
    uboot = {
      url = "github:u-boot/u-boot";
      flake = false;
    };
  };

  outputs = inputs@{ self, flake-utils, nixpkgs, uboot, aarch-images }:
    let
      buildImage = pkgs.callPackage "${aarch-images}/pkgs/build-image" { };
      pkgs = import nixpkgs { system = "aarch64-linux"; };
    in
    flake-utils.lib.eachDefaultSystem (_: rec {

      packages.sdImage = (import "${nixpkgs}/nixos" {
        configuration = ./sd.nix;
        inherit (pkgs) system;
      }).config.system.build.sdImage;

      packages.uboot = pkgs.buildUBoot rec {
        extraMakeFlags = [ "all" "u-boot.itb" ];
        defconfig = "nanopi-r2s-rk3328_defconfig";
        extraMeta = {
          platforms = [ "aarch64-linux" ];
          license = pkgs.lib.licenses.unfreeRedistributableFirmware;
        };

        enableParallelBuilding = true;

        src = uboot;
        version = uboot.rev;

        BL31 = "${pkgs.armTrustedFirmwareRK3328}/bl31.elf";
        filesToInstall = [ "u-boot.itb" "idbloader.img" ];
      };

      packages.aarch64Image = pkgs.stdenv.mkDerivation {
        name = "sd-test";
        version = "1.0.0";
        src = packages.sdImage;

        phases = [ "installPhase" ];
        noAuditTmpdir = true;
        preferLocalBuild = true;

        installPhase = "ln -s $src/sd-image/*.img $out";
      };

      defaultPackage = pkgs.callPackage "${aarch-images}/images/rockchip.nix" {
        inherit buildImage;
        inherit (packages) uboot aarch64Image;
      };
    });
}
