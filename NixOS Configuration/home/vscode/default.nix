{ lib, ... }:

{
  home.file = {
    ".config/VSCodium/User/keybindings.json".source = lib.file.mkOutOfStoreSymlink ./keybindings.json;
    ".config/VSCodium/User/settings.json".source = lib.file.mkOutOfStoreSymlink ./settings.json;
  };
}
