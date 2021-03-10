{ pkgs, lib, modulesPath, ... }:
{
  imports = [
    ./sd-image-aarch64-orangepi-r1plus.nix
  ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command ca-references flakes
    builders-use-substitutes = true
  '';

  services.udisks2.enable = lib.mkForce false;
  environment.systemPackages = with pkgs; [
    git
    neovim
    lshw
  ];

  networking = {
    networkmanager.enable = true;
  };

  users.extraUsers.orangepi = {
    isNormalUser = true;
    description = "OrangePi";
    extraGroups = [ "wheel" ];
    initialPassword = "orangepi";
  };

  sdImage.compressImage = false;
  services.openssh.enable = true;
}
