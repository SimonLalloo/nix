{ ... }:
{
  flake.nixosModules.shells =
    { pkgs, lib, config, ... }:
    let
      ompConfig = {
        console_title_template = "{{ .Shell }} in {{ .Folder }}";
        version = 3;
        final_space = true;
        palette = { grey = "#6c6c6c"; };
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
                properties = { cache_duration = "none"; };
              }
            ];
          }
        ];
      };
    in
    {
      options = {
        shells.rebuild = lib.mkOption {
          type = lib.types.str;
          default = "echo command not set";
          description = "Rebuild command for this device";
        };
        shells.zsh.enable = lib.mkEnableOption "Enable zsh configuration";
        shells.nushell.enable = lib.mkEnableOption "Enable nushell configuration";
      };

      config = lib.mkMerge [
        {
          programs.direnv = {
            enable = true;
            nix-direnv.enable = true;
          };
        }

        (lib.mkIf config.shells.zsh.enable {
          environment.etc."oh-my-posh/config.json".text = builtins.toJSON ompConfig;

          environment.systemPackages = with pkgs; [
            oh-my-posh
            yazi
          ];

          programs.zsh = {
            enable = true;
            autosuggestions.enable = true;
            syntaxHighlighting.enable = true;
            histSize = 5000;

            shellAliases = {
              rebuild = config.shells.rebuild;
              ls = "ls --color=auto";
              ll = "ls -alF";
              gg = "git status";
              gd = "git difftool";
              ssh-UU = "ssh sila3085@arrhenius.it.uu.se";
              ssh-UPPMAX = "ssh -X simonla@rackham.uppmax.uu.se";
            };

            interactiveShellInit = ''
              HISTFILE="/home/simon/.zsh_history"
              SAVEHIST=5000
              setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE

              # fzf key bindings and completion
              source ${pkgs.fzf}/share/fzf/key-bindings.zsh
              source ${pkgs.fzf}/share/fzf/completion.zsh

              # zoxide (cd replacement)
              eval "$(${lib.getExe pkgs.zoxide} init zsh --cmd cd)"

              # oh-my-posh prompt
              eval "$(${lib.getExe pkgs.oh-my-posh} init zsh --config /etc/oh-my-posh/config.json)"

              export PATH="$PATH:$HOME/.cargo/bin"
            '';
          };

          programs.zoxide.enable = true;
        })

        (lib.mkIf config.shells.nushell.enable {
          environment.systemPackages = with pkgs; [
            nushell
            carapace
          ];
        })
      ];
    };
}
