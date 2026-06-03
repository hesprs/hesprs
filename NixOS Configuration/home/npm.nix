{
  home = {
    sessionVariables = {
      PNPM_HOME = "\${HOME}/.local/share/pnpm";
    };
    sessionPath = [
      "\${PNPM_HOME}"
      "\${HOME}/.bun/bin"
    ];
  };
}
