# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ./main.nix
    ];

  # Use GRUB for booting.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.efiSupport = false;
  # Dual boot.
  boot.loader.grub.extraEntries = ''
    menuentry "Windows 10" {
      insmod part_msdos
      insmod ntfs
      insmod search_fs_uuid
      insmod ntldr
      search --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 F234E48B34E4545F
      ntldr /bootmgr
    }
    menuentry "System Shutdown" {
      echo "System shutting down..."
      halt
    }
  '';

  networking.hostName = "helium"; # Define your hostname.

  boot.kernelPackages = pkgs.linuxPackages_4_12;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/13ef86d6-611f-4f34-9e99-1c90a8c77fec";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = "performance";

  environment.systemPackages = (import ./packages.nix pkgs) ++ (with pkgs; [
    xfce.xfce4_battery_plugin xfce.xfce4-sensors-plugin arduino
  ]);

  services.xserver.synaptics = {
    enable = true;
    minSpeed = "1";
    accelFactor = "0.002";
    maxSpeed = "2";
    palmDetect = true;
    additionalOptions = ''
      Option "PalmMinWidth" "4"
      Option "PalmMinZ" "50"
    '';
  };
}
