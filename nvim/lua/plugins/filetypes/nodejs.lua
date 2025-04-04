---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("plugins.core.treesitter.languages"):add("tsx", "typescript", "javascript")
    end,
  },
  {
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local formatter
      local formatters_by_ft

      -- if require("utils").lsp.is_prettier() then
      if
        (not require("utils").lsp.is_deno())
        and (
          vim.fn.executable("prettierd") == 1
          or vim.fn.executable("prettier") == 1
        )
      then
        formatter = vim.fn.executable("prettierd") == 1 and "prettierd"
          or "prettier"
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
      else
        -- use deno_fmt as fallback
        if not require("utils").lsp.is_deno() then
          -- if no deno.json (random javascript file)

          opts.formatters = opts.formatters or {}
          opts.formatters.deno_fmt = opts.formatters.deno_fmt or {}
          opts.formatters.deno_fmt.append_args = opts.formatters.deno_fmt.append_args
            or {}
          table.insert(opts.formatters.deno_fmt.append_args, "--single-quote")
        end

        formatter = "deno_fmt"

        formatters_by_ft = {
          typescript = { formatter },
          javascript = { formatter },
          typescriptreact = { formatter },
          javascriptreact = { formatter },
          json = { formatter },
          jsonc = { formatter },
          -- markdown = { formatter },
        }
      end

      opts.formatters_by_ft = opts.formatters_by_ft or {}
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

      opts.servers.ts_ls = {
        ---@class LspconfigSetupOptsSpec
        settings = {
          commands = {
            TsLsOrganizeImports = {
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
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil or client.name ~= "eslint" then
            return
          end

          vim.keymap.set("n", "++", function()
            vim.cmd("EslintFixAll")
            local msg = "EslintFixAll Done"

            vim.notify(msg, nil, {
              title = "lspconfig",
              timeout = 350,
              hide_from_history = true,
              animate = false,
            })
          end, { desc = "EslintFixAll", buffer = args.buf })
        end,
      })

      return opts
    end,
  },
}
