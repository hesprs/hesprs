{
  lib,
  makeWrapper,
  stdenv,
  symlinkJoin,
  vscode,
  vscode-utils,
  vscode-with-extensions,
  writeText,
  islandDarkSource,
}:
let
  islandDarkSettings = islandDarkSource + "/settings.json";
  customCss =
    let
      stylesheet =
        (builtins.fromJSON (builtins.readFile islandDarkSettings))."custom-ui-style.stylesheet" or { };
    in
    builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (
        selector: rules:
        "${selector} {\n"
        + builtins.concatStringsSep "\n" (
          lib.mapAttrsToList (property: value: "  ${property}: ${value};") rules
        )
        + "\n}"
      ) (lib.filterAttrs (_: value: builtins.isAttrs value) stylesheet)
    );
  islandDarkExtension = stdenv.mkDerivation {
    pname = "islands-dark";
    version = "0.0.2";
    src = islandDarkSource;
    installPhase = ''
      mkdir -p "$out/share/vscode/extensions/bwya77.islands-dark"
      cp -r package.json themes "$out/share/vscode/extensions/bwya77.islands-dark/"
    '';
    passthru = {
      vscodeExtUniqueId = "bwya77.islands-dark";
      vscodeExtPublisher = "bwya77";
      vscodeExtName = "islands-dark";
    };
  };
  setiFolderExtension = vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-theme-seti-folder";
      publisher = "l-igh-t";
      version = "1.3.0";
      sha256 = "0y3bcgsdi3qcy4vj82a3m53dfil95p8qvc50rxdbnii8nxgcjan5";
    };
  };
  patchedVscode = vscode.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      CSS_FILE=$(find "$out/lib" -name workbench.desktop.main.css -print -quit)
      if [ -n "$CSS_FILE" ]; then
        cat ${writeText "islands-dark.css" customCss} >> "$CSS_FILE"
      fi
    '';
  });
  themedVscode = vscode-with-extensions.override {
    vscode = patchedVscode;
    vscodeExtensions = [
      islandDarkExtension
      setiFolderExtension
    ];
  };
in
symlinkJoin {
  name = "islands-dark-vscode";
  paths = [ themedVscode ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/code" --run '
      CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/Code/User"
      mkdir -p "$CONFIG_DIR"
      FLAG_FILE="$CONFIG_DIR/.islands_dark_first_run"
      if [ ! -f "$FLAG_FILE" ]; then
        if [ -f "$CONFIG_DIR/settings.json" ]; then
          cp "$CONFIG_DIR/settings.json" "$CONFIG_DIR/settings.json.pre-islands-dark"
        fi
        cp ${islandDarkSettings} "$CONFIG_DIR/settings.json"
        chmod 644 "$CONFIG_DIR/settings.json"
        touch "$FLAG_FILE"
      fi
    '
  '';
  meta = vscode.meta // {
    mainProgram = "code";
  };
}
