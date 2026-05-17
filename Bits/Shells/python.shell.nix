{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = [
    (pkgs.python3.withPackages (ps: with ps; [ requests ]))
  ];

  shellHook = ''
    echo "Entering Python development shell for your project."
  '';
}
