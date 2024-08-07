-- NOTE: <2024-07-26>
-- Outline 이 켜져 있는 버퍼가 꺼졌을때, outline 이 자동으로 꺼지지 않아
-- 번거러움.
---@type LazySpec
return {
  [1] = "hedyhli/outline.nvim",
  lazy = true,
  enabled = false,
  cmd = {
    "Outline",
    "OutlineOpen",
    "OutlineClose",
    "OutlineFocus",
    "OutlineFocusCode",
    "OutlineFocusOutline",
    "OutlineFollow",
    "OutlineStatus",
    "OutlineRefresh",
  },
  ---@type LazyKeysSpec[]
  ---@type fun(LazyPlugin, keys: LazyKeysSpec[]): nil
  keys = function()
    local prefix = require("val").prefix
    local map_keyword = require("val").map_keyword

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.supports_method("textDocument/documentSymbol") then
          vim.keymap.set(
            "n",
            prefix.sidebar .. map_keyword.symbols,
            "<cmd>Outline<CR>",
            { buffer = args.buf, desc = "outline (symbols)" }
          )
          vim.keymap.set(
            "n",
            prefix.focus .. map_keyword.symbols,
            "<cmd>OutlineFocus<CR>",
            { buffer = args.buf, desc = "outline (symbols)" }
          )
        end
      end,
    })

    ---@type LazyKeysSpec[]
    return {
      {
        [1] = prefix.sidebar .. map_keyword.symbols,
        [2] = "<cmd>OutlineClose<CR>",
        desc = "outline-close",
        ft = "Outline",
      },
      {
        [1] = prefix.sidebar .. map_keyword.symbols,
        [2] = "<cmd>Outline<CR>",
        desc = "outline",
        ft = "markodwn",
      },
    }
  end,
  dependencies = {
    "onsails/lspkind.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = function()
    local opts = {
      symbols = {
        icon_source = "lspkind",
      },
      outline_window = {
        width = 16,
        focus_on_open = false,
        auto_close = true,
      },
      symbol_folding = {
        autofold_depth = false, -- do not fold
      },
    }
    if not require("utils").enable_icon then
      opts.symbols.icon_fetcher = function()
        return ""
      end
      opts.symbols.icon_source = nil
    end

    opts.symbols.filter = {
      "String",
      "Number",
      "Boolean",
      "Array",
      "Variable",
      "Constant",
      -- "Object",
    }
    opts.symbols.filter.exclude = true

    return opts
  end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          Outline = { icon = icons.symbol },
        })
      end,
    },
  },
}
