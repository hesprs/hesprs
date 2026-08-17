final: prev: {
  obsidian =
    (prev.obsidian.override {
      electron = final.electron_43;
    }).overrideAttrs
      (old: {
        postFixup = (old.postFixup or "") + ''
          substituteInPlace $out/bin/obsidian \
            --replace-fail \
              "--wayland-text-input-version=3" \
              "--wayland-text-input-version=3 --enable-features=Vulkan,DefaultANGLEVulkan,VulkanFromANGLE --use-gl=angle --use-angle=vulkan"
        '';
      });
}
