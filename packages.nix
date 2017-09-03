pkgs: with pkgs; [
  # Basic tools
  wget curl git htop jq bc loc fdupes pandoc texlive.combined.scheme-medium

  # Utilities
  xsel xclip gnome3.gnome-screenshot qemu calcurse

  # Build systems
  pkgs.gnumake cmake rustStable.cargo gradle

  # Libraries
  SDL2 boost wxGTK30

  # Languages
  ghc rustStable.rustc lua5_3 luajit openjdk gcc clang python36 ruby nodejs-8_x
  (import ../urn { enableLuaJit = true; })

  # Games
  multimc minetest dwarf-fortress gnome3.gnome-mines
  (import packages/ccemux.nix)
  (import packages/the-powder-toy.nix)

  # Emulators
  dolphinEmuMaster dosbox stella snes9x-gtk

  # Shell and editor
  fish neovim

  # Browsers
  firefox-bin w3m

  # Web chat
  quasselClient teamspeak_client mumble

  # GTK+ and icon theme
  arc-theme paper-icon-theme

  # Office suite
  gnome3.gnome-calculator libreoffice-fresh

  # Multimedia
  gimp audacity mpv gnome3.file-roller

  # Networking
  openvpn openssh
  (import packages/update-resolv-conf.nix)

  # Xfce plugins
  xfce.xfce4_cpugraph_plugin

  # System utilities
  pavucontrol polkit_gnome exfat-utils ntfs3g
]