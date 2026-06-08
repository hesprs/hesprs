{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  pkgs,
  python3Packages,
  preStartCommands ? "",
  extras ? [ ],
  ...
}:

let
  astGrep = pkgs."ast-grep";
  extraDeps = {
    code = with python3Packages; [ tree-sitter-language-pack ];
    evals = with python3Packages; [
      datasets
      lm-eval
      pytest
      pytest-asyncio
      pytest-cov
    ];
    image = with python3Packages; [
      pillow
      onnxruntime
      rapidocr
      sentencepiece
    ];
    langchain = with python3Packages; [
      langchain-core
      langchain-openai
    ];
    mcp = with python3Packages; [ mcp ];
    memory = with python3Packages; [
      hnswlib
      sentence-transformers
      sqlite-vec
    ];
    ml = with python3Packages; [
      huggingface-hub
      torch
      transformers
    ];
    otel = with python3Packages; [
      opentelemetry-exporter-otlp-proto-http
      opentelemetry-sdk
    ];
    relevance = with python3Packages; [
      fastembed
      numpy
    ];
    reports = with python3Packages; [ jinja2 ];
    strands = with python3Packages; [ strands-agents ];
    voice = with python3Packages; [
      onnxruntime
      sounddevice
      torch
      transformers
    ];
  };
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

  dependencies =
    with python3Packages;
    [
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
    ]
    ++ lib.concatMap (extra: extraDeps.${extra}) extras;

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
