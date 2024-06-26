---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add("tsx", "typescript", "javascript")
    end,
  },
  {
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local formatter = {}
      local formatters_by_ft = {}

      if require("utils").lsp.is_deno() then
        formatter = { "deno_fmt" }
        formatters_by_ft = {
          typescript = { formatter },
          javascript = { formatter },
          typescriptreact = { formatter },
          javascriptreact = { formatter },
          json = { formatter },
          jsonc = { formatter },
          -- markdown = { formatter },
        }
      -- elseif require("utils").lsp.is_prettier() then
      else
        formatter = { "prettierd", "prettier" }
        formatters_by_ft = {
          typescript = { formatter },
          javascript = { formatter },
          typescriptreact = { formatter },
          javascriptreact = { formatter },
          json = { formatter },
          jsonc = { formatter },

          html = { formatter },
          vue = { formatter },
          css = { formatter },
          scss = { formatter },
          lss = { formatter },
          graphql = { formatter },
          handlebars = { formatter },

          -- markdown = { formatter },
          -- yaml = { formatter },
          ["markdown.mdx"] = { formatter },
        }
      end

      for key, val in pairs(formatters_by_ft) do
        opts.formatters_by_ft[key] = val
      end
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      if require("utils").lsp.is_deno() then
        return opts
      end

      if opts.servers == nil then
        opts.servers = {}
      end

      -- requires typescript-language-server
      opts.servers.tsserver = {
        ---@class LspconfigSetupOptsSpec
        settings = {
          commands = {
            OrganizeImports = {
              [1] = function()
                local params = {
                  command = "_typescript.organizeImports",
                  arguments = { vim.api.nvim_buf_get_name(0) },
                }
                vim.lsp.buf.execute_command(params)
              end,
              description = "Organize Imports",
            },
          },
        },
      }

      -- requires vscode-langservers-extracted
      opts.servers.eslint = {
        ---@class LspconfigSetupOptsSpec
        settings = {
          root_dir = require("lspconfig").util.root_pattern(unpack({
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "package.json",
          })),
        },
      }

      return opts
    end,
  },
}
