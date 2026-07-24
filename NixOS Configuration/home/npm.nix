{
  home = {
    sessionVariables = {
      PNPM_HOME = "\${HOME}/.local/share/pnpm";
    };
    sessionPath = [
      "\${PNPM_HOME}"
      "\${HOME}/.cache/.bun/bin"
    ];
  };
}
