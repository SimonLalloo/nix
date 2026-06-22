{ self, inputs, ... }:
let
  tmuxModule =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options.term.tmux.enable = lib.mkEnableOption "Enable tmux configuration";

      config = lib.mkIf config.term.tmux.enable {
        environment.systemPackages = [
          self.packages.${pkgs.stdenv.hostPlatform.system}.myTmux
        ];
      };
    };
in
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.myTmux = inputs.wrapper-modules.wrappers.tmux.wrap {
        inherit pkgs;
        prefix = "C-Space";
        modeKeys = "vi";
        statusKeys = "vi";
        mouse = true;
        sourceSensible = true;
        plugins = [
          { plugin = pkgs.tmuxPlugins.gruvbox; }
        ];
        configAfter = ''
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

          # Clipboard integration
          ${lib.optionalString pkgs.stdenv.isLinux ''
            set -s copy-command 'wl-copy'
            bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
          ''}
          ${lib.optionalString pkgs.stdenv.isDarwin ''
            set -s copy-command 'pbcopy'
            bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'pbcopy'
          ''}
        '';
      };
    };

  flake.nixosModules.tmux = tmuxModule;
  flake.darwinModules.tmux = tmuxModule;
}
