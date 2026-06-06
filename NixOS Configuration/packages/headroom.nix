# headroom.nix
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

  # Build dependencies
  nativeBuildInputs = with pythonPackages; [
    maturin
    pkgs.rustc
    pkgs.cargo
    pkgs.pkg-config
  ];

  buildInputs = with pkgs; [
    openssl
  ];

  # Runtime dependencies
  propagatedBuildInputs =
    with pythonPackages;
    [
      tiktoken
      pydantic
      litellm
      click
      rich
      opentelemetry-api
      ast-grep-cli
    ]
    ++ (pkgs.lib.optional (python.pythonOlder "3.13") tomli);

  # maturin configuration
  env.MATURIN_MANIFEST_PATH = "crates/headroom-py/Cargo.toml";

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
