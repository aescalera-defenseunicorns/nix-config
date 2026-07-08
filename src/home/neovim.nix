# nixvim.nix
# A simplified, single-file configuration that's less likely to break
# Use this if the modular approach has too many issues
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Basic options
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      termguicolors = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      swapfile = false;
      backup = false;
      undofile = true;
      splitright = true;
      splitbelow = true;
      completeopt = "menu,menuone,noselect";
    };

    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

    # Colorscheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    # Core plugins
    plugins = {
      web-devicons.enable = true;
      # File tree
      nvim-tree = {
        enable = true;
        openOnSetup = false;
        settings = {
          git = {
            ignore = false;
          };
        };
      };

      # Status line
      # lualine = {
      #   enable = true;
      #   settings.options.theme = "catppuccin";
      # };

      # Fuzzy finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      # Git signs
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
        };
      };

      # Syntax highlighting
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings = {
          indent.enable = true;
          ensure_installed = [
            "go"
            "typescript"
            "javascript"
            "nix"
            "bash"
            "json"
            "yaml"
            "markdown"
            "html"
            "css"
            "terraform"
            "dockerfile"
            "graphql"
          ];
        };
      };

      # Language servers
      lsp = {
        enable = true;
        servers = {
          # Go
          gopls.enable = true;

          # TypeScript
          ts_ls.enable = true;

          # Nix
          nil_ls = {
            enable = true;
            settings = {
              formatting = {
                command = ["alejandra"];
              };
            };
          };

          # Terraform
          terraformls.enable = true;

          # Ansible
          # ansiblels.enable = true;

          # Kubernetes/YAML
          yamlls.enable = true;

          # Bash
          bashls.enable = true;

          # Docker
          dockerls.enable = true;

          # Markdown
          marksman.enable = true;

          # GraphQL
          # graphql.enable = true;
        };

        keymaps = {
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
          lspBuf = {
            "K" = "hover";
            "gd" = "definition";
            "gr" = "references";
            "gi" = "implementation";
            "<leader>ca" = "code_action";
            "<leader>rn" = "rename";
            "<leader>f" = "format";
          };
        };
      };

      # Completion
      cmp = {
        enable = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "buffer";}
            {name = "path";}
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  fallback()
                end
              end
            '';
            "<S-Tab>" = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end
            '';
          };
        };
      };

      # Snippets
      luasnip = {
        enable = true;
        fromVscode = [
          {
            lazyLoad = true;
            paths = "${pkgs.vimPlugins.friendly-snippets}";
          }
        ];
      };

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lspFallback = true;
            timeoutMs = 500;
          };
          formatters_by_ft = {
            go = ["gofumpt"];
            javascript = ["prettier"];
            typescript = ["prettier"];
            json = ["prettier"];
            yaml = ["prettier"];
            markdown = ["prettier"];
            nix = ["alejandra"];
            terraform = ["terraform_fmt"];
            sh = ["shfmt"];
          };
        };
      };

      # Linting
      lint = {
        enable = true;
        lintersByFt = {
          go = ["golangcilint"];
          nix = ["statix"];
          terraform = ["tflint"];
          yaml = ["yamllint"];
          sh = ["shellcheck"];
          markdown = ["markdownlint"];
        };
      };

      # Terminal
      toggleterm = {
        enable = true;
        settings = {
          open_mapping = "[[<c-\\>]]";
          direction = "float";
        };
      };

      # UI helpers
      which-key.enable = true;
      indent-blankline.enable = true;
      comment.enable = true;
      nvim-autopairs.enable = true;
      vim-surround.enable = true;
      todo-comments.enable = true;
      trouble.enable = true;
    };

    # Basic keymaps
    keymaps = [
      # Navigation
      {
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Move left";
      }
      {
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Move down";
      }
      {
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Move up";
      }
      {
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Move right";
      }

      # File tree
      {
        key = "<leader>e";
        action = ":NvimTreeToggle<CR>";
        options.desc = "File tree";
      }

      # Save/quit
      {
        key = "<leader>w";
        action = ":w<CR>";
        options.desc = "Save";
      }
      {
        key = "<leader>q";
        action = ":q<CR>";
        options.desc = "Quit";
      }

      # Terminal
      {
        key = "<leader>tt";
        action = ":ToggleTerm<CR>";
        options.desc = "Terminal";
      }

      # Clear search
      {
        key = "<Esc>";
        action = ":noh<CR>";
        mode = "n";
      }
    ];

    # Install all necessary tools
    extraPackages = with pkgs; [
      # Core
      ripgrep
      fd
      fzf

      # Go
      gopls
      golangci-lint
      gofumpt

      # TypeScript
      typescript-language-server
      prettier

      # Nix
      nil
      alejandra
      statix

      # DevOps
      terraform-ls
      terraform
      tflint
      helm-ls
      kubernetes-helm
      kubectl
      yaml-language-server
      yamllint

      # Shell
      bash-language-server
      shellcheck
      shfmt

      # Markdown
      marksman
      markdownlint-cli

      # GraphQL
      graphql-language-service-cli
    ];

    # Minimal extra config
    extraConfigLua = ''
      -- Auto-lint
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })

      -- Terminal keymaps
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    '';
  };
}
