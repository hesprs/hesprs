final: prev: {
  obsidian = prev.obsidian.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.makeWrapper ];
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/obsidian \
        --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.libsecret ]}"
    '';
  });
}
