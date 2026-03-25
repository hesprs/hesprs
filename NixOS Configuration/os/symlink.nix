{ lib, config, ... }:

{
  options.home.mutableFile = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          source = lib.mkOption {
            # Accept either a Nix path (./file) or a string ("/abs/path")
            type = lib.types.either lib.types.path lib.types.str;
            description = "The source path for the symlink.";
          };
        };
      }
    );
    default = { };
    description = "Symlinks that are created only if they do not already exist (mutable).";
  };

  home.activation.mutableFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (target: attrs: ''
        target_path="$HOME/${target}"
        # Nix automatically coerces paths and strings to absolute strings here
        source_path="${attrs.source}"

        if [ -e "$target_path" ] || [ -L "$target_path" ]; then
          echo "Skipping '$target_path': already exists."
        else
          echo "Creating symlink '$target_path' -> '$source_path'"
          mkdir -p "$(dirname "$target_path")"
          ln -s "$source_path" "$target_path"
        fi
      '') config.home.mutableFile
    )}
  '';
}
