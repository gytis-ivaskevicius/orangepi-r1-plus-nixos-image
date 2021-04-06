{ pkgs, lib, ... }:
{
  imports = [
    ./sd-image-aarch64-orangepi-r1plus.nix
  ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command ca-references flakes
    builders-use-substitutes = true
  '';
  boot.extraModulePackages = [
    pkgs.r8152
  ];
  boot.kernelModules = [ "r8152" ];

  nixpkgs.config.allowUnfree = true;
  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  services.udev.extraRules = ''
    # This is used to change the default configuration of Realtek USB ethernet adapters

    ACTION!="add", GOTO="usb_realtek_net_end"
    SUBSYSTEM!="usb", GOTO="usb_realtek_net_end"
    ENV{DEVTYPE}!="usb_device", GOTO="usb_realtek_net_end"

    # Modify this to change the default value
    ENV{REALTEK_NIC_MODE}="1"

    # Realtek
    ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="0bda", ATTR{idProduct}=="8155", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="0bda", ATTR{idProduct}=="8153", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="0bda", ATTR{idProduct}=="8152", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"

    # Samsung
    ATTR{idVendor}=="04e8", ATTR{idProduct}=="a101", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"

    # Lenovo
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="304f", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="3052", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="3054", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="3057", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="3062", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="3069", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="3082", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="3098", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="7205", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="720a", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="720b", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="720c", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="7214", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="721e", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="8153", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="a359", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"
    ATTR{idVendor}=="17ef", ATTR{idProduct}=="a387", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"

    # TP-LINK
    ATTR{idVendor}=="2357", ATTR{idProduct}=="0601", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"

    # Nvidia
    ATTR{idVendor}=="0955", ATTR{idProduct}=="09ff", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"

    # LINKSYS
    ATTR{idVendor}=="13b1", ATTR{idProduct}=="0041", ATTR{bConfigurationValue}!="$env{REALTEK_NIC_MODE}", ATTR{bConfigurationValue}="$env{REALTEK_NIC_MODE}"

    LABEL="usb_realtek_net_end"
  '';


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
