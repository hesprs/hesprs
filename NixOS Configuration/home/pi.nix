{
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      npmCommand = [
        "bun"
        "--bun"
      ];
    };
  };
}
