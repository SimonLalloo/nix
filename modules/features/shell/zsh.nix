{ self, inputs, ... }:
let
  ompSettings = {
    console_title_template = "{{ .Shell }} in {{ .Folder }}";
    version = 3;
    final_space = true;
    palette.grey = "#6c6c6c";
    secondary_prompt = {
      template = "❯❯ ";
      foreground = "magenta";
      background = "transparent";
    };
    transient_prompt = {
      template = "❯ ";
      background = "transparent";
      type = "path";
      style = "plain";
      foreground_templates = [
        "{{if gt .Code 0}}red{{end}}"
        "{{if eq .Code 0}}magenta{{end}}"
      ];
    };
    blocks = [
      {
        type = "prompt";
        alignment = "left";
        newline = true;
        segments = [
          {
            template = "{{ .Path }}";
            foreground = "green";
            background = "transparent";
            type = "path";
            style = "plain";
            properties = {
              cache_duration = "none";
              style = "full";
            };
          }
          {
            template = " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>";
            foreground = "p:grey";
            background = "transparent";
            type = "git";
            style = "plain";
            properties = {
              branch_icon = "";
              cache_duration = "none";
              commit_icon = "@";
              fetch_status = true;
            };
          }
        ];
      }
      {
        type = "rprompt";
        overflow = "hidden";
        segments = [
          {
            template = "{{ .FormattedMs }}";
            foreground = "yellow";
            background = "transparent";
            type = "executiontime";
            style = "plain";
            properties = {
              cache_duration = "none";
              threshold = 5000;
            };
          }
        ];
      }
      {
        type = "prompt";
        alignment = "left";
        newline = true;
        segments = [
          {
            template = "❯";
            background = "transparent";
            type = "text";
            style = "plain";
            foreground_templates = [
              "{{if gt .Code 0}}red{{end}}"
              "{{if eq .Code 0}}magenta{{end}}"
            ];
            properties.cache_duration = "none";
          }
        ];
      }
    ];
  };
in
{
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.myOhMyPosh = inputs.wrapper-modules.wrappers.oh-my-posh.wrap {
        inherit pkgs;
        settings = ompSettings;
      };

      packages.myZsh = inputs.wrapper-modules.wrappers.zsh.wrap {
        inherit pkgs;
        hmSessionVariables = null;

        zshAliases = {
          ls = "ls --color=auto";
          ll = "ls -alF";
          gg = "git status";
          gd = "git difftool";
          ssh-UU = "ssh sila3085@arrhenius.it.uu.se";
          ssh-UPPMAX = "ssh -X simonla@rackham.uppmax.uu.se";
        };

        zshrc.content = ''
          HISTFILE="/home/simon/.zsh_history"
          HISTSIZE=5000
          SAVEHIST=5000
          setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE

          # fzf key bindings and completion
          source ${pkgs.fzf}/share/fzf/key-bindings.zsh
          source ${pkgs.fzf}/share/fzf/completion.zsh

          # zoxide (replaces cd)
          eval "$(${lib.getExe pkgs.zoxide} init zsh --cmd cd)"

          # oh-my-posh prompt
          eval "$(${lib.getExe self'.packages.myOhMyPosh} init zsh)"

          export PATH="$PATH:$HOME/.cargo/bin"
        '';
      };
    };

  flake.nixosModules.zsh =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options.shells.zsh.enable = lib.mkEnableOption "Enable zsh configuration";

      config = lib.mkIf config.shells.zsh.enable {
        users.users.simon.shell = self.packages.${pkgs.stdenv.hostPlatform.system}.myZsh;
        environment.shells = [ self.packages.${pkgs.stdenv.hostPlatform.system}.myZsh ];

        programs.zsh = {
          enable = true;
          autosuggestions.enable = true;
          syntaxHighlighting.enable = true;
        };
      };
    };
}
