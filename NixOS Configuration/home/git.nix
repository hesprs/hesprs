{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Hēsperus";
        email = "hesprs@outlook.com";
      };
      fetch.prune = "true";
      push.default = "simple";
      pull.rebase = true;
      credential.helper = "cache --timeout=7200";
      init.defaultBranch = "main";
      log.decorate = "full";
      log.date = "iso";
      merge.conflictStyle = "diff3";
    };
  };
}
