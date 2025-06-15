{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    shells.zsh.enable = mkEnableOption "Enable zsh config";

    shells.zsh.rebuild = mkOption {
      type = types.str;
      default = "echo command not set";
      description = "Rebuild command for the device";
    };
  };

  config = mkIf config.shells.zsh.enable {

    home.packages = with pkgs; [

      oh-my-posh
      yazi
    ];

    programs.zsh = {

      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # Shell aliases
      shellAliases = {
        rebuild = config.shells.zsh.rebuild;

        ls = "ls --color=auto";
        ll = "ls -alF";

        gg = "git status";
        gd = "git difftool";

        # TODO: Move these into ssh config
        ssh-UU = "ssh sila3085@arrhenius.it.uu.se";
        ssh-UPPMAX = "ssh -X simonla@rackham.uppmax.uu.se";
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "Aloxaf/fzf-tab"; }
        ];
      };

      history = {
        size = 5000;
        save = 5000;
        path = "${config.home.homeDirectory}/.zsh_history";
        ignoreDups = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        share = true;
      };

    };

    # FZF configuration
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Zoxide configuration
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        console_title_template = "{{ .Shell }} in {{ .Folder }}";
        version = 3;
        final_space = true;

        palette = { grey = "#6c6c6c"; };

        # Secondary prompt block for multiline commands
        secondary_prompt = {
          template = "❯❯ ";
          foreground = "magenta";
          background = "transparent";
        };

        # Transient prompt - shown for previously run commands
        transient_prompt = {
          template = "❯ ";
          background = "transparent";
          type = "path";
          style = "plain";
          foreground_templates =
            [ "{{if gt .Code 0}}red{{end}}" "{{if eq .Code 0}}magenta{{end}}" ];
        };

        blocks = [
          # Top left block
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
                template =
                  " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>";
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
          # Top right block
          {
            type = "rprompt";
            overflow = "hidden";
            segments = [{
              template = "{{ .FormattedMs }}";
              foreground = "yellow";
              background = "transparent";
              type = "executiontime";
              style = "plain";
              properties = {
                cache_duration = "none";
                threshold = 5000;
              };
            }];
          }
          # Main prompt block
          {
            type = "prompt";
            alignment = "left";
            newline = true;
            segments = [{
              template = "❯";
              background = "transparent";
              type = "text";
              style = "plain";
              foreground_templates = [
                "{{if gt .Code 0}}red{{end}}"
                "{{if eq .Code 0}}magenta{{end}}"
              ];
              properties = { cache_duration = "none"; };
            }];
          }
        ];
      };
    };
  };
}
