final: prev: {
  pi-coding-agent = prev.pi-coding-agent.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      prev.makeWrapper
    ];
    postFixup = (old.postFixup or "") + ''
      rm -f $out/bin/.pi-wrapped
      makeWrapper ${prev.bun}/bin/bun $out/bin/.pi-wrapped \
        --add-flags "--bun" \
        --add-flags "$out/lib/node_modules/pi-monorepo/dist/cli.js"
    '';
  });
}
