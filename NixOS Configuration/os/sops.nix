{
  sops = {
    defaultSopsFile = ../secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/user/hesprs/.config/sops/age/keys.txt";
    secrets = {
      npm-token = { };
  };
}