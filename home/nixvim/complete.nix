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

  lsp = { pkgs, ... }: {
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
            ca = "code_action";
          };
        };
        lsp-format.enable = true;
        nvim-lightbulb = { # show code actions
          enable = true;
          sign.enabled = false;
          virtualText.enabled = true;
          autocmd.enabled = true;
        };

        # highlight symbol
        illuminate.enable = true;

        nvim-cmp.sources = [{ name = "nvim_lsp"; }];
        cmp-nvim-lsp.enable = true;
      };

      # TODO: use neovim native inlay hint when api becomes stable
      extraPlugins = [ pkgs.vimPlugins.lsp-inlayhints-nvim ];
      extraConfigLuaPost = builtins.readFile ./inlay-hints.lua;

      # code lens
      keymaps = [{
        key = "<C-l>";
        action = "vim.lsp.codelens.run";
        mode = [ "n" ];
        lua = true;
      }];
      autoCmd = [{
        event = [ "CursorHold" "CursorHoldI" ];
        pattern = "*";
        callback.__raw = ''
          function (ev)
            for _, client in pairs(vim.lsp.get_active_clients({ bufnr = ev.buf })) do
              if client and client.supports_method("textDocument/codeLens") then
                vim.lsp.codelens.refresh()
              end
            end
          end
        '';
      }];
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
