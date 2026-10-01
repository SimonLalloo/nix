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

      snacks-nvim.enable = true; # Similar to Mini.nvim
      snacks-nvim.setupOpts = {
        bigfile.enabled = true;
        bigfile.line_length = 10000;
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
      mappings = {
        # These mappings have been disabled in favor of LspSaga mappings in the keymaps section
        codeAction = null;
        hover = null;
        renameSymbol = null;
        openDiagnosticFloat = null;
        nextDiagnostic = null;
        previousDiagnostic = null;
        listDocumentSymbols = null;

        # Move the goto mappings off the <leader>lg prefix onto <leader>g
        goToDefinition = "<leader>gd";
        goToDeclaration = "<leader>gD";
        goToType = "<leader>gt";
        listImplementations = "<leader>gi";
        listReferences = "<leader>gr";
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

        "gopls" = {
          settings.hints = {
            parameterNames = true;
            assignVariableTypes = true;
            compositeLiteralFields = true;
            constantValues = true;
          };
        };
      };
    };

    # TODO: DSP

    languages = {
      enableTreesitter = true;

      # Basic languages
      nix.enable = true;
      python.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };

      xml.enable = true; # Treesitter + lemminx LSP
      json.enable = true;

      go = {
        enable = true;
        extraDiagnostics.enable = true; # golangci-lint via nvim-lint
        extensions.gopher-nvim.enable = true; # :GoTests, :GoIfErr, :GoTagAdd, :GoImpl
        format = {
          enable = true;
          type = [
            "goimports"
            "gofumpt"
          ];
        };
      };
    };

    # NVF has no XML preset for conform-nvim, so wire xmllint in directly.
    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        formatters.xmllint = {
          command = lib.getExe' pkgs.libxml2 "xmllint";
          args = [
            "--format"
            "-"
          ];
        };
        formatters_by_ft.xml = [ "xmllint" ];
      };
    };

    extraPlugins = {
      vimtex = {
        package = pkgs.vimPlugins.vimtex;
      };

      # Test runner: run/inspect Go tests without a full DAP setup.
      nvim-nio = {
        package = pkgs.vimPlugins.nvim-nio; # neotest dependency
      };
      neotest-golang = {
        package = pkgs.vimPlugins.neotest-golang;
        after = [ "nvim-nio" ];
      };
      neotest = {
        package = pkgs.vimPlugins.neotest;
        after = [ "neotest-golang" ];
        setup = ''
          require('neotest').setup {
            adapters = {
              require('neotest-golang') {
                runner = "gotestsum", -- steadier output than raw `go test -json`
              },
            },
          }
        '';
      };
    };

    # gotestsum is the recommended runner for neotest-golang.
    extraPackages = [ pkgs.gotestsum ];

    binds.whichKey = {
      enable = true;
      register."<leader>g" = "+Goto"; # match LSP keybind change
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
        key = "<leader>gn"; # Replace LSP next diagnostic
        mode = "n";
        silent = true;
        action = ":Lspsaga diagnostic_jump_next<CR>";
        desc = "Go to next diagnostic";
      }
      {
        key = "<leader>gp"; # Replace LSP previous diagnostic
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
        key = "<leader>gv"; # Like <leader>gd, but in a vertical split
        mode = "n";
        silent = true;
        action = "<cmd>lua vim.cmd.vsplit(); vim.lsp.buf.definition()<cr>";
        desc = "Go to definition in vertical split";
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
      {
        key = "<leader>sg";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_status()<cr>";
        desc = "Git status";
      }

      # Neotest
      {
        key = "<leader>rt";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('neotest').run.run()<cr>";
        desc = "Run nearest test";
      }
      {
        key = "<leader>rf";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>";
        desc = "Run tests in file";
      }
      {
        key = "<leader>rs";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('neotest').summary.toggle()<cr>";
        desc = "Toggle test summary";
      }
      {
        key = "<leader>rp";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('neotest').output_panel.toggle()<cr>";
        desc = "Toggle test output panel";
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
