# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ./main.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "xenon"; # Define your hostname.

  boot.kernelPackages = pkgs.linuxPackages_4_12;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/423c4347-554a-43af-b449-707ae45c5d76";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D05D-6ABB";
      fsType = "vfat";
    };

  fileSystems."/mnt/hdd" =
    { device = "/dev/disk/by-uuid/243205de-6503-42f7-baa6-12aaf3c2a68e";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 12;

  powerManagement.cpuFreqGovernor = "performance";

  environment.systemPackages = (import ./packages.nix pkgs) ++ (with pkgs; [
  ]);
}
