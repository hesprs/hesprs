{ config, ... }:

{
  sops = {
    secrets.npm-token = { };
    templates.".npmrc".content = ''
      //registry.npmjs.org/:_authToken=${config.sops.placeholder.npm-token}
      prefix=/home/hesprs/.local/share/npm
    '';
  };
  home = {
    sessionVariables = {
      PNPM_HOME = "\${HOME}/.local/share/pnpm";
      NPM_HOME = "\${HOME}/.local/share/npm/bin";
    };
    sessionPath = [
      "\${PNPM_HOME}"
      "\${NPM_HOME}"
    ];
    file.".npmrc".source = config.sops.templates.".npmrc".path;
  }
}
