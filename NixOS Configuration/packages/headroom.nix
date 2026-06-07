{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  pkgs,
  python3Packages,
  preStartCommands ? "",
  ...
}:

let
  astGrep = pkgs."ast-grep";
in
python3Packages.buildPythonPackage {
  __structuredAttrs = true;
  pname = "headroom-ai";
  version = "0.23.0";

  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/9a/df/502abccb76b70acee2e1a70dd5c1ece7918aecc7f457a084b16a45b1a1e9/headroom_ai-0.23.0-cp313-cp313-manylinux_2_28_x86_64.whl";
    hash = "sha256-0QxyfPv4yPPLHjb7VYahjHY+cP8U9FunPSxV1uvM0/A=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  dependencies = with python3Packages; [
    click
    botocore
    fastapi
    h2
    litellm
    pydantic
    rich
    tiktoken
    uvicorn
    opentelemetry-api
  ];

  pythonRelaxDeps = [
    "litellm"
  ];

  pythonRemoveDeps = [
    "ast-grep-cli"
  ];

  makeWrapperArgs =
    lib.optionals (preStartCommands != "") [
      "--run"
      preStartCommands
    ]
    ++ [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [ astGrep ])
    ];

  pythonImportsCheck = [
    "headroom"
  ];

  doCheck = false;

  meta = {
    description = "The Context Optimization Layer for LLM Applications";
    homepage = "https://headroom-docs.vercel.app";
    license = lib.licenses.asl20;
    mainProgram = "headroom";
    platforms = lib.platforms.linux;
  };
}
