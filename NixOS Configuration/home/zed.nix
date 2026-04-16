{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "rust"
    ];
    userSettings = {
      hour_format = "hour24";
    };
  };
}
