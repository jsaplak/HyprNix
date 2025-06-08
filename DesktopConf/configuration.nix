{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.timeout = 60;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "nixos"; 

  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  hardware.graphics = {
    enable = true;
    enable32bit = true;
  }

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
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
    
  # Hpyrland needs options
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
};

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  
  users.users.nixd = {
    isNormalUser = true;
    description = "nixd";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs.firefox.enable = true;
  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;

 fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" "IosevkaTerm" ]; } )

  ];

  environment.systemPackages = with pkgs; [
  	#-Nvim Envir
	neovim
	ripgrep
	git
	gh
	stow
	#-Essentials
	google-chrome
	obsidian
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
	#libgcc
	#gnumake42
  jdk
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
