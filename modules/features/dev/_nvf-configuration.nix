{
  pkgs,
  lib,
  ...
}:
{
  vim = {
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    options = {
      tabstop = 2;
      wrap = true;
      foldlevelstart = 99;
      ignorecase = true;
      smartcase = true;
    };

    binds.whichKey.enable = true;
    statusline.lualine.enable = true;
    notes.todo-comments.enable = true;
    runner.run-nvim.enable = true;

    git = {
      gitsigns.enable = true;
      vim-fugitive.enable = true;
    };

    visuals = {
      fidget-nvim.enable = true;
      rainbow-delimiters.enable = true;
    };

    ui = {
      colorizer.enable = true; # Highlight colors
      colorful-menu-nvim.enable = true; # Colors in the completion menu
      illuminate.enable = false; # Highlight word under cursor
      nvim-ufo.enable = true; # Folding
      ui2.enable = true;
      modes-nvim.enable = false; # Color current line. Breaks visual mode when combined with which-key
    };

    utility = {
      sleuth.enable = true; # Auto-set tabstop, etc.
      direnv.enable = true; # Sync shell with direnv

      oil-nvim.enable = true; # Better netrw
      oil-nvim.gitStatus.enable = true;

      # Snacks doesn't seem to work properly
      snacks-nvim.enable = true; # Similar to Mini.nvim
      snacks-nvim.setupOpts = {
        bigfile.enabled = true;
        dashboard.enabled = false;
        notify.enabled = true;
        notifier.enabled = true;
        picker.enabled = true;
        explorer.enabled = false;
        image.enabled = true; # uses Kitty graphics protocol
      };
    };

    mini = {
      ai.enable = true; # Text objects like a(.
      pairs.enable = true; # Autopair brackets, etc.
      surround.enable = true; # Modify surroundings like brackets.
      indentscope.enable = true;
      files.enable = false; # File explorer thing
      pick.enable = false;
      extra.enable = false; # Add explorer via picker

      animate.enable = true;
      animate.setupOpts = {
        scroll.enable = false; # Disable broken scroll
      };
    };

    # TODO: figure out theming
    telescope = {
      enable = true;
      extensions = [
        {
          name = "fzf";
          packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
          setup = {
            fzf = {
              fuzzy = true;
            };
          };
        }
      ];
      setupOpts = {
        defaults.color_devicons = true;
        theme = "dropdown";
      };
    };

    autocomplete = {
      # Autocomplete engine
      blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        setupOpts.signature.enabled = true;
        mappings = {
          confirm = "<C-y>";
          next = "<C-n>";
          previous = "<C-p>";
          scrollDocsUp = "<C-b>";
          scrollDocsDown = "<C-f>";
        };
      };
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      lightbulb.enable = true;
      lspkind.enable = true; # Add icons

      presets.harper.enable = true; # Spellcheck

      lspsaga.enable = true;
      # These mappings have been disabled in favor of LspSaga mappings in the keymaps section
      mappings = {
        codeAction = null;
        hover = null;
        renameSymbol = null;
        openDiagnosticFloat = null;
        nextDiagnostic = null;
        previousDiagnostic = null;
        listDocumentSymbols = null;
      };

      servers = {
        "harper" = {
          # Restrict Harper to certain filetypes.
          filetypes = lib.mkForce [
            "text" # .txt
            "markdown" # .md
            "tex" # .tex
            "asciidoc" # .adoc
            "typst" # .typ
            "gitcommit" # commit messages
          ];
        };
      };
    };

    # TODO: DSP

    languages = {
      enableTreesitter = true;

      # Basic languages
      nix.enable = true;
      python.enable = true;

      go.enable = true;
    };

    extraPlugins = {
      vimtex = {
        package = pkgs.vimPlugins.vimtex;
      };
    };

    keymaps = [
      # LSP Saga stuff
      {
        key = "<leader>la"; # Replace LSP code action
        mode = "n";
        silent = true;
        action = ":Lspsaga code_action<CR>";
        desc = "Code action";
      }
      {
        key = "<leader>le"; # Replace LSP error
        mode = "n";
        silent = true;
        action = ":Lspsaga show_cursor_diagnostics<CR>";
        desc = "Show error";
      }
      {
        key = "<leader>lgn"; # Replace LSP next diagnostic
        mode = "n";
        silent = true;
        action = ":Lspsaga diagnostic_jump_next<CR>";
        desc = "Go to next diagnostic";
      }
      {
        key = "<leader>lgp"; # Replace LSP previous diagnostic
        mode = "n";
        silent = true;
        action = ":Lspsaga diagnostic_jump_prev<CR>";
        desc = "Go to previous diagnostic";
      }
      {
        key = "K"; # Replace LSP hover
        mode = "n";
        silent = true;
        action = ":Lspsaga hover_doc<CR>";
      }
      {
        key = "<leader>lr"; # Replace LSP rename
        mode = "n";
        silent = true;
        action = ":Lspsaga rename<CR>";
        desc = "Rename symbol";
      }
      {
        key = "<leader>lS"; # Replace LSP Symbols
        mode = "n";
        silent = true;
        action = ":Lspsaga outline<CR>";
        desc = "Show symbols/outline";
      }
      {
        key = "<leader>ll";
        mode = "n";
        silent = true;
        action = ":Lspsaga finder<CR>";
        desc = "Show references & usages";
      }

      # Snacks keybinds
      {
        key = "<leader>t";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.explorer.reveal()<cr>";
        desc = "Open file explorer";
      }

      # Gitsigns
      {
        key = "<leader>hB";
        mode = "n";
        silent = true;
        action = "<cmd>Gitsigns blame<cr>";
        desc = "Enable git blame";
      }

      # Basic stuff
      {
        key = "<leader>y";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "\"+y";
        desc = "Yank to clipboard";
      }
      {
        key = "<Esc>";
        mode = "n";
        silent = true;
        action = "<cmd>nohlsearch<CR>";
      }

      # Keybinds to make split navigation easier. (Ctrl+ vim keys)
      {
        key = "<C-h>";
        mode = "n";
        action = "<C-w><C-h>";
      }
      {
        key = "<C-l>";
        mode = "n";
        action = "<C-w><C-l>";
      }
      {
        key = "<C-j>";
        mode = "n";
        action = "<C-w><C-j>";
      }
      {
        key = "<C-k>";
        mode = "n";
        action = "<C-w><C-k>";
      }
    ];

    autocmds = [
    ];
  };
}
