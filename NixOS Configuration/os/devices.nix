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
      noProxy = "localhost,127.0.0.1,192.168.0.0/16,fe80::/10";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 5173 ];
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

  # make Intel RAPL energy counters readable without root (CPU power draw)
  services.udev.extraRules = ''
    SUBSYSTEM=="powercap", KERNEL=="intel-rapl*", RUN+="${pkgs.coreutils}/bin/chmod a+r /sys/%p/"
  '';

  security.wrappers.nethogs = {
    source = "${pkgs.nethogs}/bin/nethogs";
    capabilities = "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+pe";
    owner = "root";
    group = "root";
  };

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
