{ config, ... }:

{
  home = {
    sessionVariables = {
      PNPM_HOME = "\${HOME}/.local/share/pnpm";
      NPM_HOME = "\${HOME}/.local/share/npm/bin";
    };
    sessionPath = [
      "\${PNPM_HOME}"
      "\${NPM_HOME}"
    ];
  };
}
