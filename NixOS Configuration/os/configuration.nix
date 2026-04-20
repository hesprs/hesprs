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
    ./stylix.nix
    ./login.nix
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

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (pkg: true);
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
      description = "Hēsperus";
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
  services.gnome.gnome-keyring.enable = true;
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ]; # share portals

  #packages
  environment.systemPackages = with pkgs; [
    # applications
    thunderbird # email client
    obsidian # note-taking
    zed-editor # code editor
    v2rayn # VPN client
    qq
    wechat
    zen # browser
    google-chrome # browser
    gradia # image editor
    libreoffice-qt-fresh # office suite
    noctalia # desktop UI
    opencode # agrntic coding
    gh # GitHub CLI
    # bunx oh-my-opencode-slim@latest install

    # system utilities
    loupe # image viewer
    showtime # video viewer
    decibels # audio player
    papers # PDF viewer
    snapshot # camera
    nautilus # file manager
    seahorse # password manager
    gnome-calculator # calculator
    gnome-characters # character finder
    brightnessctl # screen brightness control
    tree # directory tree viewer
    ripgrep # search tool
    sops # secrets manager
    grim # screenshot getter
    slurp # screenshot region selector
    wl-clipboard # clipboard manager
    tuigreet # login interface
    mission-center # system monitor

    # runtimes / compilers
    python3 # Python
    jupyter # Jupyter Notebook
    nodejs_25 # JavaScript / TypeScript
    bun # JavaScript / TypeScript
    deno # Jupyter Notebook TS support
    rustc # Rust
    javaPackages.compiler.openjdk25 # Java
    gcc # C/C++

    # package managers / language servers / formatters
    uv # Python
    pnpm # JavaScript / TypeScript
    cargo # Rust
    gnumake # Make
    nixfmt # Nix formatter
    nixd # Nix language server
    oxfmt # TypeScript / JavaScript formatter
  ];

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      sf-pro-display
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
