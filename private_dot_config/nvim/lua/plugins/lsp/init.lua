return {

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function(_, _)
      local on_attach = function(client, buffer)
        local bufopts = { noremap = true, silent = true, buffer = buffer }

        vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", bufopts)

        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", bufopts)
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", bufopts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", bufopts)
        vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", bufopts)

        local format = function()
          vim.lsp.buf.format({ bufnr = buffer })
        end

        if client.supports_method("textDocument/formatting") then
          vim.keymap.set("n", "<leader>c=", format, bufopts)
        end
      end

      -- Merge all capabilities
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      require("lspconfig")["lua_ls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              -- Stop prompting about 'luassert'. See https://github.com/neovim/nvim-lspconfig/issues/1700
              checkThirdParty = false,
            },
            telementry = {
              enable = false,
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      })
    end,
  },

  -- cmdline tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      -- Some tools we want to ensure are installed. For language servers,
      -- should instead add to the mason-lspconfig config
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      -- Install all tools
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- lsp servers
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "mason.nvim",
    },
    opts = {
      -- Available language servers we can let mason-lspconfig install:
      -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
      ensure_installed = {
        "lua_ls",
        "marksman",
      },
    },
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
          nls.builtins.code_actions.shellcheck,
        },
      }
    end,
  },
}
