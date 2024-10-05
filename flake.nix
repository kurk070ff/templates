{
  description = "My collection of nix flake templates";

  outputs = { self }: {
    templates = {
      bevy = {
        path = ./bevy;
        description = "A flake to get a bevy project set up quickly";
      };
      ipynb = {
        path = ./ipynb;
        description = "A flake for working with ipynb notebooks in vscode";
      };
    };
  };
}
