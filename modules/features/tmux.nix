{ ... }:
{
  flake.nixosModules.tmux =
    { pkgs, lib, config, ... }:
    {
      options = {
        term.tmux.enable = lib.mkEnableOption "Enable tmux configuration";
      };

      config = lib.mkIf config.term.tmux.enable {
        programs.tmux = {
          enable = true;
          keyMode = "vi";
          plugins = with pkgs.tmuxPlugins; [ gruvbox ];
          extraConfig = ''
            set -g prefix C-Space
            unbind C-b
            bind C-Space send-prefix

            set -g mouse on

            # Hot reloading
            unbind r
            bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

            # Splitting panes
            unbind %
            bind | split-window -h
            unbind '"'
            bind - split-window -v

            # Vim-style pane navigation
            bind -r k select-pane -U
            bind -r j select-pane -D
            bind -r h select-pane -L
            bind -r l select-pane -R

            # Copying with wl-copy (Wayland clipboard)
            set -s copy-command 'wl-copy'
            bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
          '';
        };
      };
    };
}
