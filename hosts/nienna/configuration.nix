{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  #powerManagement.cpuFreqGovernor = "performance";

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
    hardware.pulseaudio.support32Bit = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  boot = {
    plymouth.enable = true;
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 0;
      grub = {
        devices = [ "nodev" ];
        enable = true;
        splashImage = null;
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 21;
        copyKernels = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  networking = {
    hostName = "nienna";
    networkmanager.enable = true;
    interfaces = {
      #eno1.useDHCP = true;
      wlo1.useDHCP = true;
    };
    dhcpcd.wait = "background";
    dhcpcd.extraConfig = "noarp";
    #extraHosts = "";
  };

  time.timeZone = "Asia/Kolkata";
  services.kmonad = {
    enable = true;
    keyboards = {
        Ducky-One-2-mini = {
            device = "/dev/input/by-id/usb-Ducky_Ducky_One2_Mini_RGB_DK-V1.10-201231-event-kbd";
            config = builtins.readFile ../../users/xaerru/config/kmonad/ducky.kbd;
            };
        };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      mouse.accelProfile = "adaptive";
      mouse.accelSpeed = "10.0";
    };
    xkbOptions = "compose:ralt";
    autoRepeatDelay = 300;
    autoRepeatInterval = 15;
  };
  virtualisation.virtualbox.host.enable = true;
  users.users.xaerru = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "input" "vboxusers" ];
  };

  services.udisks2 = {enable = true;};

  fonts.fonts = with pkgs; [
    noto-fonts
    #noto-fonts-cjk
    source-code-pro
    noto-fonts-emoji
    font-awesome_5
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  environment.systemPackages = with pkgs; [ vim wget gcc git gnumake lynx ];
  services.getty.autologinUser = "xaerru";

  environment.etc."X11/xorg.conf.d/20-intel.conf" = {
    text = ''
      Section "Device"
        Identifier "Intel Graphics"
        Driver "intel"
        Option "TearFree" "true"
        Option "AccelMethod" "sna"
        Option "SwapbuffersWait" "true"
      EndSection
    '';
  };

  programs.dconf.enable = true;
  system.stateVersion = "21.11";
}

