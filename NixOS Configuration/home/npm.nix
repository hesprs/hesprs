{
  home = {
    sessionVariables = {
      PNPM_HOME = "\${HOME}/.local/share/pnpm";
      npm_config_prefix = "\${HOME}/.local/share/npm";
    };
    sessionPath = [
      "\${PNPM_HOME}"
      "\${npm_config_prefix}/bin"
    ];
  };
}
