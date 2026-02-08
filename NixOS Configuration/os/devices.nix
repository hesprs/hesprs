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
      wifi.backend = "iwd";
      wifi.scanRandMacAddress = false;
      wifi.powersave = true;
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

  services.tlp.enable = true;
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
}
