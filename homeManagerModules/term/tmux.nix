{ config, lib, pkgs, ... }:

with lib;

{
  options = { term.tmux.enable = mkEnableOption "Enable tmux config"; };

  config = mkIf config.term.tmux.enable {

    programs.tmux = {
      enable = true;

      # Set leader key
      prefix = "C-Space";

      # Enable mouse support
      mouse = true;

      # Set vi mode for copy mode
      keyMode = "vi";

      # Custom key bindings
      extraConfig = ''
        # Hot reloading (reload config)
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

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = sensible;
          extraConfig = "";
        }
        # TODO: Get a better theme
        { plugin = gruvbox; }
      ];
    };
  };
}
