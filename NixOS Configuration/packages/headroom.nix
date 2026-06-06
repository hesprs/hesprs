# packages/headroom.nix
{
  pkgs ? import <nixpkgs> { },
}:

let
  python = pkgs.python312;
  pythonPackages = python.pkgs;
in
pythonPackages.buildPythonPackage rec {
  pname = "headroom-ai";
  version = "0.23.0";
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "chopratejas";
    repo = "headroom";
    rev = "v${version}";
    hash = "sha256-4pQUSi8dU85tm5WY8Z/ZEN8O/ccGDDVIC3SnNBvUZTY=";
  };

  # Rust toolchain is top-level pkgs, not pythonPackages.
  nativeBuildInputs = with pkgs; [
    rustc
    cargo
    pkg-config
  ];

  buildInputs = with pkgs; [
    openssl
  ];

  build-system = [ pkgs.maturin ];

  propagatedBuildInputs =
    with pythonPackages;
    [
      tiktoken
      pydantic
      litellm
      click
      rich
      opentelemetry-api
    ]
    ++ pkgs.ast-grep ++ pkgs.lib.optional (python.pythonOlder "3.13") tomli;

  # maturin needs to know where the PyO3 crate lives.
  env.MATURIN_MANIFEST_PATH = "crates/headroom-py/Cargo.toml";

  # Isolate cargo state to avoid store contamination.
  preBuild = ''
    export CARGO_HOME=$TMPDIR/cargo-home
    mkdir -p $CARGO_HOME
  '';

  doCheck = false;
  pythonImportsCheck = [ "headroom" ];

  meta = with pkgs.lib; {
    description = "Context compression layer for AI agents";
    homepage = "https://github.com/chopratejas/headroom";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "headroom";
  };
}
