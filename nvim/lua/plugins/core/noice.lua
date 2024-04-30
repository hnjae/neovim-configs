-- vim.api.nvim_set_keymap()

-- replace cmdline, messages, popupmenu

local val = require("val")

---@type LazySpec[]
local M = {
  {
    [1] = "folke/noice.nvim",
    lazy = true,
    enabled = true,
    event = {
      -- "VimEnter",
      "VeryLazy",
    },
    ---@type LazyKeysSpec[]
    keys = {
      {
        [1] = val.map_keyword.hover_scroll_up,
        [2] = function()
          if not require("noice.lsp").scroll(-4) then
            return val.map_keyword.hover_scroll_up
          end
        end,
        expr = true,
        mode = { "n", "i", "s" },
        silent = true,
      },
      {
        [1] = val.map_keyword.hover_scroll_down,
        [2] = function()
          if not require("noice.lsp").scroll(4) then
            return val.map_keyword.hover_scroll_down
          end
        end,
        expr = true,
        mode = { "n", "i", "s" },
        silent = true,
      },
    },
    dependencies = {
      { [1] = "rcarriga/nvim-notify", optional = true },
      "MunifTanjim/nui.nvim",
      {
        [1] = "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = function()
          require("state.treesitter-langs"):add(
            "vim",
            "regex",
            "bash",
            "query",
            "markdown",
            "markdown_inline"
          )
        end,
      },
    },
    opts = function(_, opts)
      local ret = {
        -- notify = {
        --   enabled = false,
        -- },
        lsp = {
          progress = {
            enabled = true,
            throttle = 200, -- default 1000/30 (33.3)
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = require("utils").is_treesitter,
            ["vim.lsp.util.stylize_markdown"] = require("utils").is_treesitter,
            ["cmp.entry.get_documentation"] = require("utils").is_plugin(
              "nvim-cmp"
            ),
          },
          hover = {
            enabled = false,
          },
        },
        messages = {
          -- Messages shown by lsp servers
          enabled = true,
          -- view = "mini",
        },
        popupmenu = {
          -- backend = "cmp",
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          -- command_palette = true, -- position the cmdline and popupmenu together
          -- long_message_to_split = false, -- long messages will be sent to a split
          -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      }

      opts = vim.tbl_deep_extend("keep", ret, opts)

      if not opts.lsp.signature then
        opts.lsp.signature = { enabled = false }
      end

      return opts
    end,
    config = function(_, opts)
      require("noice").setup(opts)

      -- vim.keymap.set({ "n", "i", "s" }, "<c-j>", function()
      --   if not require("noice.lsp").scroll(4) then
      --     return "<c-f>"
      --   end
      -- end, { silent = true, expr = true })
      --
      -- vim.keymap.set({ "n", "i", "s" }, "<c-k>", function()
      --   if not require("noice.lsp").scroll(-4) then
      --     return "<c-b>"
      --   end
      -- end, { silent = true, expr = true })
    end,
  },
  -- {
  --   [1] = "nvim-lualine/lualine.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     local modules = require("lualine_require").lazy_require({
  --       noice = "noice",
  --     })
  --
  --     local get_color = function()
  --       local utils = require("utils")
  --       local highlights = {
  --         "GitSignsChange",
  --         "WarningMsg",
  --       }
  --
  --       local color
  --       for _, highlight in pairs(highlights) do
  --         color = utils.get_color(highlight)
  --         if color ~= "" then
  --           return color
  --         end
  --       end
  --
  --       return "#ff9e64"
  --     end
  --
  --     vim.list_extend(opts.sections.lualine_x, {
  --       {
  --         component = {
  --           [1] = modules.noice.api.status.search.get,
  --           cond = modules.noice.api.status.search.has,
  --           color = { fg = get_color() },
  --         },
  --         priority = 0,
  --       },
  --       {
  --         component = {
  --           [1] = modules.noice.api.status.command.get,
  --           cond = modules.noice.api.status.command.has,
  --           color = { fg = get_color() },
  --         },
  --         priority = 0,
  --       },
  --     })
  --   end,
  -- },
}

return M
