{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./desktop.nix
    ./hardware.nix
    ./devices.nix
    ./greetd.nix
    ./stylix.nix
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
    gc = {
      automatic = true;
      options = "--delete-older-than 4d";
    };
    optimise.automatic = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Libertas";
  networking.networkmanager.enable = true;

  # Localization
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  users.users = {
    hesprs = {
      isNormalUser = true;
      description = "Hēsperus";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
  };

  # services
  security.rtkit.enable = true;
  programs.dconf.enable = true; # Gnome APP settings
  programs.nix-ld.enable = true; # run external binaries
  programs.chromium.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };

  nixpkgs = {
    overlays = [
      (import ./codium)
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (pkg: true);
    };
  };

  #packages
  environment.systemPackages = with pkgs; [
    thunderbird
    obsidian
    codium
    wtype
    v2rayn
    qq
    wechat
    mission-center
    zen
    gradia
    ripgrep
    onlyoffice-desktopeditors

    loupe # image viewer
    showtime # video viewer
    decibels # audio player
    papers # PDF viewer
    snapshot # camera
    nautilus # file manager
    gnome-calculator
    gnome-characters
    brightnessctl # screen brightness control

    zip

    grim
    slurp
    wl-clipboard

    python3
    uv
    nodePackages_latest.nodejs
    pnpm
    nixfmt
    cargo
    rustc
    gcc
    gnumake
    javaPackages.compiler.openjdk25
    opencode
    # mycli # MySQL cli
    google-chrome

    awww
  ];

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
        (pkgs.callPackage ./fonts/SFDisplay { })
        nerd-fonts.jetbrains-mono
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
