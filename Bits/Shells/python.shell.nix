let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  buildInputs = [
    (pkgs.python3.withPackages (
      ps: with ps; [
        # ...
      ]
    ))
  ];

  shellHook = ''
    echo "Entering Python development shell for your project."
  '';
}
