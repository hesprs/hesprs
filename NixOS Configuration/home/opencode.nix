{
  stylix.targets.opencode.colors.override.withHashtag.base00 = "#00000000";

  home.sessionVariables.OPENCODE_ENABLE_EXA = 1;
  programs.opencode = {
    enable = true;
    tui = {
      plugin = [ "opencode-subagent-statusline" ];
    };
    settings = {
      autoupdate = false;
      lsp = true;
      provider = {
        anthropic.options.baseURL = "https://anpin.ai/v1";
        openai.options = {
          baseURL = "https://anpin.ai/v1";
          headerTimeout = 30000;
        };
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

      # https://github.com/anomalyco/opencode/issues/31422
      formatter = false;
    };
  };
}
