{
  stylix.targets.opencode.colors.override.withHashtag.base00 = "#00000000";

  home.sessionVariables.OPENCODE_ENABLE_EXA = 1;
  programs.opencode = {
    enable = true;
    settings = {
      autoupdate = false;
      lsp = true;
      provider = {
        anthropic.options.baseURL = "https://apishop.org/v1";
        openai.options.baseURL = "https://www.nodapi.com/v1";
        deepseek.options.baseURL = "https://www.nodapi.com/v1";
        google.options.baseURL = "https://www.nodapi.com/v1";
      };

      agent = {
        build.disable = true;
        plan.disable = true;
        general.disable = true;
        explore.disable = true;
        scout.disable = true;
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
