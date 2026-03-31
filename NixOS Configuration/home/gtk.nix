{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "MacTahoe-Dark-normal-default-standard";
      package = pkgs.mactahoe-gtk-theme;
    };
  };
}
