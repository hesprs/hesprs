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
    ./mime.nix
    ./stylix.nix
    ./secrets.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
    gc = {
      automatic = true;
      options = "--delete-older-than 4d";
    };
    optimise.automatic = true;
    extraOptions = ''
      !include ${config.sops.templates.nix-github-conf.path}
    '';
  };

  nixpkgs.config.allowUnfree = true;

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
    LC_TIME = "en_US.UTF-8";
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

  programs = {
    dconf.enable = true; # Gnome APP settings
    nix-ld.enable = true; # run external binaries
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };

  #packages
  environment.systemPackages = with pkgs; [
    # applications
    betterbird # email client
    obsidian # note-taking
    v2rayn # VPN client
    vscodium # code editor
    qq
    zen # browser
    gradia # image editor
    wordcraft # office suite
    gh # GitHub CLI
    agent-browser # agentic browser control
    cua-driver # agentic computer control

    # GNOME shell extensions
    gnomeExtensions.mosaic # tiling window manager
    gnomeExtensions.blur-my-shell # blur for the MacTahoe theme
    rounded-window-corners-reborn # round non-GTK windows
    gnomeExtensions.rounded-corners # round monitor corners
    gnomeExtensions.user-themes # load MacTahoe shell theme
    gnomeExtensions.appindicator # system tray icons
    gnomeExtensions.desktop-cube # 3D workspace switcher
    gnomeExtensions.just-perfection # hide the dash from overview

    # system utilities
    glib.bin # Gnome CLI tool
    ripgrep # search tool
    sops # secrets manager
    gnupg # GPG
    gpu-screen-recorder-gtk # screen recorder GUI
    wl-clipboard # clipboard manager
    unzip # zipper
    wayland-scroll-factor # touchpad scroll speed

    # runtimes / compilers
    python3 # Python
    bun # JavaScript / TypeScript
    (linkFarm "node-bun" [
      # node -> bun shim
      {
        name = "bin/node";
        path = "${bun}/bin/bun";
      }
    ])
    rustc # Rust
    gcc # C/C++

    # package managers / language servers / formatters
    uv # Python
    cargo # Rust
    gnumake # Make
    nixfmt # Nix formatter
    nixd # Nix language server
  ];

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      sf-pro-display
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };

  virtualisation = {
    podman.enable = true;
    containers.policy.default = [ { type = "insecureAcceptAnything"; } ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
