
# NixOS image for OrangePi R1 Plus

Still WIP but it seems to work just fine.

Installation steps:
1. `nix build`
2. `sudo dd if=./result of=/dev/SD_CARD iflag=direct oflag=direct bs=16M status=progress`


