{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # Bootloader.
  # Boot into Other Linux installs by disabling systemd and enabling GRUB and OS probe
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.theme = "${
          (pkgs.fetchFromGitHub {
            owner = "semimqmo";
            repo = "sekiro_grub_theme";
            rev = "1affe05f7257b72b69404cfc0a60e88aa19f54a6";
            hash = "sha256-wTr5S/17uwQXkWwElqBKIV1J3QUP6W2Qx2Nw0SaM7Qk=";
          })
	  }/Sekiro";
	


  boot.loader.timeout = 60;
  boot.loader.efi.efiSysMountPoint = "/boot";
  
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "America/New_York";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      
      prime = {
        offload.enable = false;
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        };    
      };
  };

  # Hyprland Config
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    };
  environment.sessionVariables = {
    # If cursor becomes invisble
    #WLR_NOHARDWARE_CURSORS = "1"; #Nvidia Option
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    };
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixl = {
    isNormalUser = true;
    description = "nixl";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    google-chrome
    vscodium
    ];
  };

  programs.firefox.enable = true;
  programs.steam.enable = true;

  #TO DO
  #programs.zsh.enable = true;
  #users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
 



  services.ollama = {
  enable = true;
  acceleration = "cuda";
  };

 fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" "IosevkaTerm" ]; } )

  ];

  environment.systemPackages = with pkgs; [
	neovim	
	jdk
	ripgrep
	git
	gh
	stow
	#-Essentials
	google-chrome
	obsidian
	discord
	webcord
	wget
	curl
	spotify
	fzf
	blueman
	bluez
	pavucontrol
	cowsay
	steam
	hyprshot
	vscodium
	prismlauncher
	#-Coreutils
	cpufrequtils
	grub2
	hdparm
	iverilog
	pciutils
	lshw
	#-Software Dev tools 
	libgcc
	gnumake42
	(
	python3.withPackages (
		p: with p; [
		scapy
		pip
		pandas
		requests
		beautifulsoup4
		html2text
		pycrypto
		nmapthon2
		flask
		pygame
		]
	)
	)

	#-Security Soft
	wireshark
	ghidra
	gdb
	nmap
	#metasploit
	#armitage

	#-Cosmetics and Hyprland apps
	neofetch
	btop
	kitty
	waybar
	eww
	dunst
	libnotify
	swww
	rofi-wayland
	phinger-cursors
	brightnessctl
	hyprpaper

    (pkgs.waybar.overrideAttrs (oldAttrs: {
    	mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
	})
    )






  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # Hpyrland needs options
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
