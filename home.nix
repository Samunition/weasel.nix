{ pkgs, ... }: {
  config = {
    home.stateVersion = "24.05";
    home.packages = with pkgs; [
      neovim
      tmux
      git
      nerdctl
    ];
  };
}
