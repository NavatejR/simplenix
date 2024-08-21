# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    plymouth.enable = true;
    #plymouth.theme="bgrt";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Nvidia drivers
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    hardware.nvidia.prime = {
      offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:0:2";
    nvidiaBusId = "PCI:1:0:0";
    };

  # Intel Drivers
    nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };

    # OpenGL
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

 
    environment.sessionVariables = {
    	LIBVA_DRIVER_NAME = "iHD";
 	};

  # Additional vm-guest-services
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    services.spice-webdavd.enable = true;

  # Starship shell, steam and virt-viewer
  programs = {
    starship = {
    enable = true;
    settings = {
      add_newline = false;
      buf = {
        symbol = " ";
      };
      c = {
        symbol = " ";
      };
      directory = {
        read_only = " 󰌾";
      };
      docker_context = {
        symbol = " ";
      };
      fossil_branch = {
        symbol = " ";
      };
      git_branch = {
        symbol = " ";
      };
      golang = {
        symbol = " ";
      };
      hg_branch = {
        symbol = " ";
      };
      hostname = {
        ssh_symbol = " ";
      };
      lua = {
        symbol = " ";
      };
      memory_usage = {
        symbol = "󰍛 ";
      };
      meson = {
        symbol = "󰔷 ";
      };
      nim = {
        symbol = "󰆥 ";
      };
      nix_shell = {
        symbol = " ";
      };
      nodejs = {
        symbol = " ";
      };
      ocaml = {
        symbol = " ";
      };
      package = {
        symbol = "󰏗 ";
      };
      python = {
        symbol = " ";
      };
      rust = {
        symbol = " ";
      };
      swift = {
        symbol = " ";
      };
      zig = {
        symbol = " ";
      };
     };
    };
    virt-manager.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
        };
      };
  
  # Enable Stylix and Gruvbox Theme (Dark)
    stylix = {
    enable = true;
    image = ./gruvbox_astro.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    targets.plymouth.logoAnimated = true;
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  # Extra Portal Configuration
  #programs.hyprland = {
  #  enable = true;
  #  nvidiaPatches = true;
  #  xwayland.enable = true;
  #};
  #xdg.portal = {
  #  enable = true;
  #  wlr.enable = true;
  #  extraPortals = [
  #    pkgs.xdg-desktop-portal-gtk
  #    pkgs.xdg-desktop-portal
  #  ];
  #  configPackages = [
  #    pkgs.xdg-desktop-portal-gtk
  #    pkgs.xdg-desktop-portal-hyprland
  #    pkgs.xdg-desktop-portal
  #  ];
  #};

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.navatej = {
    isNormalUser = true;
    description = "Navatej Ratnan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kate
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

  # System Packages
  wget
  vim
  htop
  btop
  git
  curl
  rsync
  warp-terminal
  tmux
  nh
  libvirt
  lolcat
  cmatrix
  eza
  ydotool
  unzip
  unrar
  ffmpeg
  cowsay
  bat
  virt-viewer
  appimage-run
  neovide
  spotify
  virt-manager

  # User Packages
  neofetch
  neovim
  themechanger
  fastfetch
  plasma-theme-switcher
  catppuccin
  ani-cli
  dra-cla
  kde-gruvbox
  catppuccin-kde
  plasma-theme-switcher
  protonup-qt
  protontricks
  obsidian
  chatgpt-cli
  rclone
  #swww
  #rofi-wayland

  # Developing Tools
  python39
  zig
  erlang
  ruby
  rustc
  rustup
  clojure
  temurin-jre-bin
  zed-editor
  nginx
  docker
  android-tools
  esptool
  github-desktop
  flutter
  fantomas 
  azure-cli
  azure-cli-extensions.fzf
  azure-cli-extensions.nsp
  azure-functions-core-tools
  azure-cli-extensions.nginx
  azure-cli-extensions.fleet

  # Misc
  john
  whatsapp-for-linux
  rclone
  fzf
  nixos-bgrt-plymouth
  gucharmap
  bitcoin
  electrum
  cgminer
  litecoin
  libreoffice-qt-fresh
  anime-downloader
  davinci-resolve
  bookworm
  kdePackages.okular

  # Power Saving Tools
  auto-cpufreq
  thermald
  linuxKernel.packages.linux_6_9.cpupower
  cpufrequtils
  powertop

  # Gaming / Wine Utilities
  bottles
  pciutils
  wineWowPackages.waylandFull
  wine
  winetricks
  winePackages.fonts
  protonup
  lutris
  ];

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono"]; })
  ];

  # List services that you want to enable:
  services = {
      openssh.enable = true;
      thermald.enable = true;
      flatpak.enable = true;
      #fprintd.enable = true;
    };

   #security.pam.services.sddm = {};
   ##security.pam.services.sddm.fprintAuth = true;
  
  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  # Bluetooth Support
  #hardware.bluetooth.enable = true;
  #hardware.bluetooth.powerOnBoot = true;
  #services.blueman.enable = true;

  # Virtualization / Containers
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # This value determines the NixOS release from which the default
  system.stateVersion = "24.05"; # Did you read the comment?

}
