return {
  "phaazon/hop.nvim",
  -- version = "2.0.x",
  branch = "v2",
  enabled = true,
  lazy = true,
  opts = {
    { keys = "etovxqpdygfblzhckisuran" },
  },
  ---@type LazyKeys[]
  keys = {
    {
      "f",
      nil,
      remap = true,
    },
    {
      "F",
      nil,
      remap = true,
    },
    {
      "t",
      nil,
      remap = true,
    },
    {
      "T",
      nil,
      remap = true,
    },
  },
  config = function(plugin, opts)
    -- local sniprun = require("sniprun")
    -- sniprun.setup(opts)
    local hop = require("hop")
    hop.setup(opts)

    local directions = require("hop.hint").HintDirection
    local mapping = {
      f = function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end,
      F = function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end,
      t = function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
      end,
      T = function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
      end,
    }

    for _, key in pairs(plugin.keys) do
      vim.keymap.set("n", key[1], mapping[key[1]], { remap = true })
    end
  end,
}
