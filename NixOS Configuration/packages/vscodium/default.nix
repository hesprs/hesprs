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
  vscodium = prev.vscodium.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ bun ];
    postInstall = (oldAttrs.postInstall or "") + ''
      ${bun}/bin/bun ${patchScript} $out ${stylesCSS}
    '';
    postFixup = (oldAttrs.postFixup or "") + ''
      substituteInPlace $out/bin/codium \
        --replace-fail \
          '--enable-features=WaylandWindowDecorations' \
          '--enable-features=WaylandWindowDecorations,Vulkan,UseSkiaRenderer' \
        --replace-fail \
          '--enable-wayland-ime=true' \
          '--enable-unsafe-webgpu --enable-wayland-ime=true'
    '';
  });
}
