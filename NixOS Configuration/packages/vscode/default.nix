final: prev:
let
  patchScript = builtins.path {
    path = ./patch.ts;
    name = "codium-patch-script";
  };
  stylesCSS = builtins.path {
    path = ./styles.css;
    name = "codium-styles-css";
  };
  bun = prev.bun;
in
{
  vscode = prev.vscode.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ bun ];
    postInstall = (oldAttrs.postInstall or "") + ''
      ${bun}/bin/bun ${patchScript} $out ${stylesCSS}
    '';
  });
}
