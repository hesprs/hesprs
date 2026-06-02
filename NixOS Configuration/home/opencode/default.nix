{
  home.file = {
    ".config/opencode/oh-my-opencode-slim.json".source = ./oh-my-opencode-slim.json;
    ".config/opencode/oh-my-opencode-slim" = {
      recursive = true;
      source = ./oh-my-opencode-slim;
    };
  };

  stylix.targets.opencode.colors.override.withHashtag.base00 = "#00000000";

  programs.opencode = {
    enable = true;
    context = ./AGENTS.md;
    settings = {
      autoupdate = false;
      lsp = true;
      plugin = [
        "oh-my-opencode-slim@latest"
        "@tarquinen/opencode-dcp@latest"
      ];
      provider = {
        anthropic.options.baseURL = "https://coultra.blueshirtmap.com/v1";
        openai.options.baseURL = "https://coultra.blueshirtmap.com/v1";
        google.options.baseURL = "https://coultra.blueshirtmap.com/v1";
      };

      agent = {
        build.disable = true;
        plan.disable = true;
        general.disable = true;
        explore.disable = true;
      };

      formatter.oxfmt = {
        command = [
          "oxfmt"
          "$FILE"
        ];
        extensions = [
          ".js"
          ".ts"
          ".jsx"
          ".tsx"
          ".md"
          ".json"
          ".jsonc"
          ".json5"
          ".yaml"
          ".yml"
          ".toml"
          ".html"
          ".angular"
          ".vue"
          ".css"
          ".scss"
          ".less"
          ".mdx"
        ];
      };
    };
  };
}
