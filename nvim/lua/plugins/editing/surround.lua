---@type LazySpec
return {
  -- NOTE: use S in visual-mode <2024-05-09>
  [1] = "kylechui/nvim-surround",
  lazy = true,
  version = "*",
  -- event = { "InsertEnter" },
  event = { "VeryLazy" },
  opts = {},
  specs = {
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      opts = {
        -- deprecated in Which-Key v3
        -- operators = {
        --   ys = "surround-insert",
        --   yss = "surround-normal-cur",
        --   yS = "surround-normal-line",
        --   ySS = "surround-normal-cur-line",
        --   -- S = "surround-visual",
        --   -- gS = "surround-visual-line",
        --   ds = "surround-delete",
        --   cs = "surround-change",
        --   cS = "surround-change-line",
        -- },
      },
    },
  },
}
