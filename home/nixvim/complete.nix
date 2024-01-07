let
  base = { ... }: {
    programs.nixvim = {
      plugins = {
        nvim-cmp = {
          enable = true;
          mapping = let select_opts = "{behavior = cmp.SelectBehavior.Select}";
          in {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";

            "<Up>" = "cmp.mapping.select_prev_item(${select_opts})";
            "<Down>" = "cmp.mapping.select_next_item(${select_opts})";

            "<C-p>" = "cmp.mapping.select_prev_item(${select_opts})";
            "<C-n>" = "cmp.mapping.select_next_item(${select_opts})";

            "<C-e>" = "cmp.mapping.abort()";

            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };
      };
    };
  };

  luasnip = { ... }: {
    programs.nixvim = {
      plugins = {
        luasnip = { enable = true; };
        nvim-cmp = {
          snippet.expand = "luasnip";
          sources = [{ name = "luasnip"; }];
        };
      };
    };
  };

  lsp = { ... }: {
    programs.nixvim = {
      plugins = {
        lsp = {
          enable = true;
          keymaps.lspBuf = {
            K = "hover";
            gD = "references";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
          };
        };
        lsp-format.enable = true;
        nvim-lightbulb.enable = true;

        nvim-cmp.sources = [{ name = "nvim_lsp"; }];
        cmp-nvim-lsp.enable = true;
      };
    };
  };

  with-icons = { ... }: {
    programs.nixvim = { plugins.lspkind = { enable = true; }; };
  };

  none-ls = { ... }: {
    programs.nixvim = { plugins = { none-ls = { enable = true; }; }; };
  };

  path = { ... }: {
    programs.nixvim = {
      plugins = {
        cmp-path.enable = true;
        nvim-cmp.sources = [{ name = "path"; }];
      };
    };
  };
in {
  inherit base luasnip lsp none-ls path with-icons;

  default = { ... }: { imports = [ base luasnip lsp none-ls path ]; };
}
