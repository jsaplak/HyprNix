  
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
  boot.loader.efi.efiSysMountPoint = "/boot";
  
    # AMD driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  #boot.initrd.kernelModules = [ "nvidia" ];

  # OpenGL Enable
  hardware.graphics= {
    enable = true;
    enable32Bit = true;
    };
  #services.xserver.videoDrivers = ["amdgpu"];
  #services.xserver.videoDrivers = ["nvidia"];
  #hardware.nvidia.modesetting.enable = true;
  
  # Powermanagment(needed to fix CPU throttling, Nix set my cores in powersave mode by default)
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
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

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  #services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
 
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  #hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.libinput.enable = true;

  users.users.jsd = {
    isNormalUser = true;
    description = "jsd";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs.firefox.enable = true;
  programs.steam.enable = true;
  
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  nixpkgs.config.allowUnfree = true;

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
    HCC_AMDGPU_TARGET = "gfx1031";
    };
    rocmOverrideGfx = "10.3.1";
    };

  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" "IosevkaTerm" ]; } )

  ];

  environment.systemPackages = with pkgs; [
  	#-Nvim Envir
	neovim
	ripgrep
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
	#AMD specific Drivers
	driversi686Linux.amdvlk
	nvtopPackages.panthor
	networkmanagerapplet
	#-Coreutils
	cpufrequtils
	grub2
	hdparm
	iverilog
	pciutils
	#-Software Dev tools 
	libgcc
	gnumake42
	git
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
