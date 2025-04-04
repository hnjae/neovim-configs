---@type LazySpec
return {
  -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
  [1] = "folke/trouble.nvim",
  lazy = true,
  cond = not vim.g.vscode,
  enabled = true,
  version = "v3.*",
  dependencies = {
    { [1] = "nvim-tree/nvim-web-devicons", optional = true },
    { [1] = "onsails/lspkind-nvim", optional = true }, -- my personal dependency
  },
  cmd = {
    "Trouble",
  },
  opts = function()
    local is_lspkind, lspkind = pcall(require, "lspkind")

    local res = {
      icon = require("utils").use_icons,
      icons = {},
    }

    if is_lspkind then
      res.icons.kind = lspkind.symbol_map
    end

    return res
  end,
  keys = function()
    local prefix = require("globals").prefix
    local map_keyword = require("globals").map_keyword

    return {
      {
        [1] = prefix.sidebar .. map_keyword.symbols,
        [2] = "<cmd>Trouble symbols toggle<CR>",
        desc = "symbol (Trouble)",
      },
      {
        [1] = prefix.sidebar .. map_keyword.diagnostics,
        [2] = "<cmd>Trouble diagnostics toggle<CR>",
        desc = "diagnostics (Trouble)",
      },
      {
        [1] = prefix.sidebar .. string.upper(map_keyword.diagnostics),
        [2] = "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostics.severity.ERROR<CR>",
        desc = "diagnostics-error (Trouble)",
      },
      {
        [1] = prefix.sidebar .. "q",
        [2] = "<cmd>Trouble quickfix toggle<CR>",
        desc = "quickfix (Trouble)",
      },
      {
        [1] = prefix.sidebar .. map_keyword.lsp,
        [2] = "<cmd>Trouble lsp toggle<CR>",
        desc = "lsp definitions / references / ... (Trouble)",
      },
    }
  end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function(_, opts)
        local get_name = function()
          local trouble_opts = require("trouble.config").options

          local words = vim.split(trouble_opts.mode, "[%W]")
          for i, word in ipairs(words) do
            words[i] = word:sub(1, 1):upper() .. word:sub(2)
          end

          return table.concat(words, " ")
        end

        local name
        if require("utils").use_icons then
          local icon = require("globals").icons.tools
          name = function()
            return string.format("%s %s", icon, get_name())
          end
        else
          name = get_name
        end

        local extension = {
          sections = {
            lualine_c = { { name } },
          },
          inactive_sections = {
            lualine_c = { { name } },
          },
          filetypes = { "Trouble" },
        }

        if not opts.extensions then
          opts.extensions = {}
        end

        table.insert(
          opts.extensions,
          vim.tbl_deep_extend(
            "keep",
            require("globals.plugins.lualine").__get_basic_layout(),
            extension
          )
        )

        local icons = require("globals").icons
        require("plugins.core.lualine.utils.buffer-attributes"):add({
          trouble = { display_name = "Trouble", icon = icons.tools },
        })
      end,
    },
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      opts = function(_, opts)
        opts.icons = opts.icons or {}
        opts.icons.rules = opts.icons.rules or {}

        table.insert(
          opts.icons.rules,
          { plugin = "trouble.nvim", icon = "󱍼", color = "green" }
        )
      end,
    },
  },
}
