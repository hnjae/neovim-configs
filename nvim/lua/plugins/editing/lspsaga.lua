---@type LazySpec
local M = {
  [1] = "nvimdev/lspsaga.nvim",
  lazy = true,
  event = "LspAttach",
  enabled = true,
  cond = not vim.g.vscode,
  dependencies = {
    { [1] = "nvim-tree/nvim-web-devicons", optional = true },
    {
      [1] = "nvim-treesitter/nvim-treesitter",
      optional = true,
      opts = function()
        require("plugins.core.treesitter.languages"):add("markdown", "markdown_inline")
      end,
    },
  },
  opts = function(_, opts)
    local utils = require("utils")
    local map_keyword = require("globals").map_keyword

    local default_opts = {
      scroll_preview = {
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
      },
      code_action = {
        show_server_name = true,
        extend_gitsigns = utils.is_plugin("gitsigns.nvim"),
      },

      lightbulb = {
        -- NOTE: textDocument/codeAction 을 지원안할 경우, 에러 메시지 송출 <2024-04-07>
        enable = false,
      },

      hover = {
        open_cmd = "!" .. utils.get_browser_cmd(),
      },
      symbol_in_winbar = {
        -- alternatives <2024-07-26>:
        -- https://github.com/utilyre/barbecue.nvim (uses nvim-navic inside)
        -- https://github.com/SmiteshP/nvim-navic
        -- https://github.com/Bekaboo/dropbar.nvim
        -- Breadcrumbs
        -- enable = not utils.is_plugin("lualine.nvim"),
        enable = true,
        delay = 500, -- default: 300
      },
      diagnostic = {
        extend_relatedInformation = true,
        exec_action = map_keyword.execute,
      },
      finder = {
        -- methods = {},
        keys = {
          -- shuttle = "[w",
          -- toggle_or_open = "o",
          vsplit = map_keyword.vsplit,
          split = map_keyword.split,
          tabe = map_keyword.tab,
          -- tabnew = "r",
          -- quit = "q",
          -- close = "<C-c>k",
        },
      },

      -- require(lspsaga.symbol.winbar).get_bar()
      definition = {
        width = 0.6,
        height = 0.5,
        save_pos = false,
        keys = {
          edit = string.format("<C-c>%s", map_keyword.current),
          tabe = string.format("<C-c>%s", map_keyword.tab),
          vsplit = string.format("<C-c>%s", map_keyword.vsplit),
          split = string.format("<C-c>%s", map_keyword.split),
          -- quit = "q",
          -- close = "<C-c>k",
        },
      },
    }
    default_opts.ui = require("utils").use_icons
        and {
          border = "rounded",
          devicons = true,
          expand = "", -- nf-cod-expand_all
          collapse = "", -- nf-cod-collapse_all
          code_action = require("globals").icons.signs.code_action,
          actionfix = " ", -- nf-cod-lightbulb_autofix
          imp_sign = "", -- nf-cod-wand
        }
      or {
        devicons = false,
        code_action = "!",
        actionfix = "!F",
        imp_sign = "I",
      }

    opts = vim.tbl_deep_extend("keep", default_opts, opts or {})

    return opts
  end,
  cmd = {
    "Lspsaga",
  },
  ---@type fun(LazyPlugin, keys: LazyKeysSpec[]): nil
  keys = function(_, keys)
    local globals = require("globals")
    local map_keyword = globals.map_keyword
    local prefix = globals.prefix

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        local keymap_opts = { buffer = args.buf }
        local mappings = {
          ["textDocument/definition"] = {
            lhs = prefix.peek .. "d",
            rhs = "<cmd>Lspsaga peek_definition<CR>",
            desc = "peek-definition (lspsaga)",
          },
          ["textDocument/typeDefinition"] = {
            lhs = prefix.peek .. "p",
            rhs = "<cmd>Lspsaga peek_type_definition<CR>",
            desc = "peek-type-definition (lspsaga)",
          },
          ["textDocument/publishDiagnostic"] = {
            {
              -- overrides neovim's default keymap
              lhs = "[d",
              rhs = function()
                require("lspsaga.diagnostic"):goto_prev()
              end,
              desc = "prev-diagnostic (lspsaga)",
            },
            {
              -- overrides neovim's default keymap
              lhs = "]d",
              rhs = function()
                require("lspsaga.diagnostic"):goto_next()
              end,
              desc = "next-diagnostic (lspsaga)",
            },
            {
              lhs = "[r",
              rhs = function()
                require("lspsaga.diagnostic"):goto_prev({
                  severity = vim.diagnostic.severity.ERROR,
                })
              end,
              desc = "prev-diagnostic-error (lspsaga)",
            },
            {
              lhs = "]r",
              rhs = function()
                require("lspsaga.diagnostic"):goto_next({
                  severity = vim.diagnostic.severity.ERROR,
                })
              end,
              desc = "next-diagnostic-error (lspsaga)",
            },
            {
              lhs = "[w",
              rhs = function()
                require("lspsaga.diagnostic"):goto_prev({
                  severity = vim.diagnostic.severity.WARN,
                })
              end,
              desc = "prev-diagnostic-warn (lspsaga)",
            },
            {
              lhs = "]w",
              rhs = function()
                require("lspsaga.diagnostic"):goto_next({
                  severity = vim.diagnostic.severity.WARN,
                })
              end,
              desc = "next-diagnostic-warn (lspsaga)",
            },
          },
        }
        for method, specs in pairs(mappings) do
          if client.supports_method(method) then
            for _, spec in ipairs(specs.rhs and { specs } or specs) do
              vim.keymap.set(
                spec.mode and spec.mode or "n",
                spec.lhs,
                spec.rhs,
                vim.tbl_extend("error", keymap_opts, { desc = spec.desc })
              )
            end
          end
        end

        local mappings2 = {
          {
            methods = {
              "textDocument/implementation",
              "textDocument/references",
            },
            specs = {
              {
                -- print references and implementation in popup window
                lhs = string.format(
                  "%s%s%s",
                  prefix.buffer,
                  map_keyword.lsp,
                  "f"
                ),
                rhs = "<cmd>Lspsaga finder<CR>",
                desc = "lspsaga-finder",
              },
            },
          },
        }
        local check_methods = function(methods)
          for _, method in ipairs(methods) do
            if client.supports_method(method) then
              return true
            end
          end
          return false
        end

        for _, mapping in ipairs(mappings2) do
          if check_methods(mapping.methods) then
            for _, spec in ipairs(mapping.specs) do
              vim.keymap.set(
                spec.mode and spec.mode or "n",
                spec.lhs,
                spec.rhs,
                vim.tbl_extend("error", keymap_opts, { desc = spec.desc })
              )
            end
          end
        end
      end,
    })
  end,
  config = function(_, opts)
    require("lspsaga").setup(opts)

    -- overrides neovim's default functions
    vim.lsp.buf.hover = function()
      vim.api.nvim_command("Lspsaga hover_doc")
    end
    -- NOTE: 이렇게 하면 에러 발생. <2024-07-24>
    -- deressing 플러그인의 input ui 로 대체 <2024-07-26>
    -- vim.lsp.buf.rename = function()
    --   vim.api.nvim_command("Lspsaga rename")
    -- end
    vim.lsp.buf.code_action = function()
      vim.api.nvim_command("Lspsaga code_action")
    end
    vim.lsp.buf.definition = function()
      vim.api.nvim_command("Lspsaga goto_definition")
    end
    -- vim.lsp.buf.incoming_calls = function()
    --   vim.api.nvim_command("Lspsaga incoming_calls")
    -- end
    -- vim.lsp.buf.outgoing_calls = function()
    --   vim.api.nvim_command("Lspsaga outgoing_calls")
    -- end
    vim.lsp.buf.goto_type_definition = function()
      vim.api.nvim_command("Lspsaga goto_type_definition")
    end

    -- 아래 방식으로 작동 안됨.
    -- local lspsaga_diagnostic = require("lspsaga.diagnostic")
    -- vim.diagnostic.goto_prev = function(...)
    --   lspsaga_diagnostic:goto_prev(...)
    -- end
    -- vim.diagnostic.goto_next = function(...)
    --   local args = { ... }
    --   lspsaga_diagnostic:goto_next({
    --     severity = args[1].severity,
    --   })
    -- end
  end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function(_, opts)
        -- :h lualine-Custom-components

        -- DISABLE LUALINE INTEGRATION <2024-11-08>
        -- local modules = require("lualine_require").lazy_require({
        --   lspsaga = "lspsaga.symbol.winbar",
        -- })
        --
        -- local disabled_buftypes = {
        --   "picker",
        --   "prompt",
        --   "nofile",
        --   "nowrite",
        --   "quickfix",
        --   "terminal",
        -- }
        --
        -- local component = {
        --   [1] = modules.lspsaga.get_bar,
        --   cond = function()
        --     return not vim.tbl_contains(disabled_buftypes, vim.bo.buftype)
        --   end,
        --   fmt = function(str)
        --     -- NOTE: nil 이 아닌  "nil" 이거 오타 아님. <2024-04-05>
        --     return str == "nil" and "" or str
        --   end,
        -- }
        --
        -- if not opts.tabline then
        --   opts.tabline = {}
        -- end
        -- if not opts.tabline.lualine_a then
        --   opts.tabline.lualine_a = {}
        -- end
        -- table.insert(opts.tabline.lualine_a, component)

        local icons = require("globals").icons
        require("plugins.core.lualine.utils.buffer-attributes"):add({
          sagafinder = { display_name = "SagaFinder", icon = icons.search },
          saga_codeaction = {
            display_name = "Saga CodeAction",
            icon = icons.lightbulb,
          },
          sagarename = { display_name = "SagaRename", icon = icons.textbox },
          sagaoutline = { display_name = "SagaOutline", icon = icons.symbol },
        })
      end,
    },
  },
}

return M
