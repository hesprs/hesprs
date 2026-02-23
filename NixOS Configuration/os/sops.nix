{
  sops = {
    defaultSopsFile = ../secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/user/.config/sops/age/keys.txt";
    secrets = {
      npm-token = { };
    };
  };
}
