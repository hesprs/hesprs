{
  pkgs,
  ...
}:

{
  # networking
  networking = {
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        scanRandMacAddress = false;
        powersave = false;
      };
    };
    proxy = {
      httpProxy = "http://127.0.0.1:10808";
      httpsProxy = "http://127.0.0.1:10808";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        5173
      ];
    };
    interfaces = {
      wlan0 = {
        #macAddress = "";
      };
    };
  };
  services.resolved.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  services.pulseaudio.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      PLATFORM_PROFILE_ON_AC = "performance";
      RUNTIME_PM_ON_BAT = "auto";
      USB_AUTOSUSPEND = "1";
      SOUND_POWER_SAVE_ON_BAT = "1";
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
    };
  };
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = false;
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
  };

  # touchpad
  services.libinput = {
    enable = true;
    touchpad = {
      additionalOptions = ''Option "ScrollingPixelDistance" "10"'';
      disableWhileTyping = false;
    };
  };

  boot.extraModprobeConfig = ''
    options rtw88_pci disable_aspm=y
    options rtw88_core disable_lps_deep=y
  '';
}
