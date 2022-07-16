{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  powerManagement.cpuFreqGovernor = "performance";

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  boot = {
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
  };

  networking = {
    hostName = "nienna";
    wireless = {
      enable = true;
      interfaces = [ "wlo1" ];
      networks = {
        JoJo = {
          pskRaw =
            "25b9c5903c7a501df7c23e6884b272a9a292a895e72d01a1eaf43f860d5d2b09";
        };
      };
    };
    interfaces = {
      #eno1.useDHCP = true;
      wlo1.useDHCP = true;
    };
    dhcpcd.wait = "background";
    dhcpcd.extraConfig = "noarp";
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

