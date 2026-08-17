{
  pkgs,
  ...
}:

{
  # networking
  networking = {
    hostName = "Libertas";
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
    # interfaces.wlan0.macAddress = "";
  };
  services.resolved.enable = true;

  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;

  # power management
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
  };

  # touchpad
  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = false;
  };

  boot.extraModprobeConfig = ''
    options rtw88_pci disable_aspm=y
    options rtw88_core disable_lps_deep=y
  '';
}
