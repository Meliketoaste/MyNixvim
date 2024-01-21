{ self, pkgs, ... }: {
  # Import all your configuration modules here
  imports = [ ./bufferline.nix ];
  config = {
    globals.mapleader = " ";
    options = {
      updatetime = 100; # Faster completion

      number = true;
      relativenumber = true;

      autoindent = true;
      clipboard = "unnamedplus";
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;

      ignorecase = true;
      incsearch = true;
      smartcase = true;

      swapfile = false;
      undofile = true; # Build-in persistent undo
    };
    #  colorschemes.gruvbox.enable = true;
    #  colorschemes.rose-pine.enable = true;
    #  colorschemes.rose-pine.disableItalics = true;

    #  colorschemes.base16 = {
    #    enable = true;
    #    colorscheme = "rose-pine";
    #
    #  };
    extraConfigLua = /* lua */ '' 
      vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
    '';


    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
      transparentBackground = false;
      integrations.native_lsp.enabled = true;
      colorOverrides.mocha = {
        base = "#11111B";

      };
    };
    
    keymaps = [
      {
        # Toggle NvimTree
        key = "<C-n>";
        action = "<CMD>NvimTreeToggle<CR>";
      }
      {
        # Format file
        key = "<space>fm";
        action = "<CMD>lua vim.lsp.buf.format()<CR>";
      }
      {
        # Toggle UndoTree
        key = "<leader>ut";
        action = "<CMD>UndotreeToggle<CR>";
      }
#      {
#        # Escape terminal mode using ESC
#        mode = "t";
#        key = "<esc>";
#        action = "<C-\\><C-n>";
#      }
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>g";
      }


      {
        action =
          "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {winblend = 0, previewer = false,}) <CR>";
        key = "<leader>/";
        options.desc = "[/] Fuzzily search in current buffer";
      }
    ];

    plugins = {
      lualine.enable = true;
      nvim-tree.enable = true;
      nvim-tree.hijackNetrw = false;

      undotree.enable = true;

      telescope.enable = true;
      telescope.extensions.fzy-native.enable = true;

      #    oil.enable = true;
      indent-blankline.enable = true;
      treesitter = {
        enable = true;
        nixGrammars = true;
        indent = true;
      };
      treesitter-context.enable = false;
      rainbow-delimiters.enable = true;

      cursorline.enable = false;

      luasnip.enable = true;
      which-key.enable = true;
    };

    plugins.none-ls = {
      enable = true;
      sources = {
        diagnostics = {
          golangci_lint.enable = true;
          ktlint.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
        };
        formatting = {
          fantomas.enable = true;
          gofmt.enable = true;
          goimports.enable = true;
          ktlint.enable = true;
          nixfmt.enable = true;
          markdownlint.enable = true;
          rustfmt.enable = true;
        };
      };
    };

    plugins.toggleterm = {
      enable = true;
      openMapping = "<C-t>";
      direction = "horizontal";
    };

    plugins.lsp = {
      enable = true;
      servers = {
        lua-ls.enable = true;
        nil_ls.enable = true;
        bashls.enable = true;
        clangd.enable = true;
        elixirls.enable = true;
        fsautocomplete.enable = true;
        gopls.enable = true;
        kotlin-language-server.enable = true;
        nixd.enable = true;
        ruff-lsp.enable = true;

      };
      keymaps.lspBuf = {
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
      };
    };
    plugins.rust-tools.enable = true;
    plugins.cmp_luasnip = { enable = true; };
    plugins.cmp-nvim-lsp = { enable = true; };
    plugins.cmp-path = { enable = true; };
    plugins.cmp-buffer = { enable = true; };
    plugins.cmp-emoji = { enable = true; };

    plugins.nvim-cmp = {
      enable = true;
      autoEnableSources = true;
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "luasnip"; }
        { name = "nvim_lua"; }
      ];
      formatting = {
        fields = [ "abbr" "kind" "menu" ];
        format =
          # lua
          ''
            function(_, item)
              local icons = {
                Namespace = "󰌗",
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰆧",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈚",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰊄",
                Table = "",
                Object = "󰅩",
                Tag = "",
                Array = "[]",
                Boolean = "",
                Number = "",
                Null = "󰟢",
                String = "󰉿",
                Calendar = "",
                Watch = "󰥔",
                Package = "",
                Copilot = "",
                Codeium = "",
                TabNine = "",
              }

              local icon = icons[item.kind] or ""
              item.kind = string.format("%s %s", icon, item.kind or "")
              return item
            end
          '';
      };
      snippet = { expand = "luasnip"; };

      window = {
        completion = {
          winhighlight =
            "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
            scrollbar = false;
          sidePadding = 0;
          border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
        };

        documentation = {
          border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
          winhighlight =
            "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
        };
      };

      mapping = {
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-j>" = "cmp.mapping.select_next_item()";
        "<C-k>" = "cmp.mapping.select_prev_item()";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.close()";
        "<CR>" =
          "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
        "<Tab>" = {
          modes = [ "i" "s" ];
          action =
            # lua
            ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require("luasnip").expand_or_jumpable() then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
                else
                  fallback()
                end
              end
            '';
        };
        "<S-Tab>" = {
          modes = [ "i" "s" ];
          action =
            # lua
            ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require("luasnip").jumpable(-1) then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                else
                  fallback()
                end
              end
            '';
        };
      };

    };
  };

}
