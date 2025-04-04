-- 다이나믹한 창 크기 조절

---@type LazySpec
return {
  [1] = "anuvyklack/windows.nvim",
  event = "WinNew",
  lazy = true,
  cond = not vim.g.vscode,
  dependencies = {
    { "anuvyklack/middleclass" },
    { [1] = "anuvyklack/animation.nvim", enabled = false },
  },
  keys = {
    {
      [1] = "<leader>m",
      [2] = "<cmd>WindowsMaximize<cr>",
      desc = "windows-zoom",
    },
  },
  opts = {
    ignore = {
      buftype = {
        "picker",
        "prompt",
        "nofile",
        "nowrite",
        "quickfix",
        "terminal",
      },
      filetype = {
        "notify",
        "noice",
        "TelescopePrompt",
        "lazy",
        "tagbar",
        "fzf",
        "OverseerList",
        "Outline",
        "toggleterm",
        "NvimTree",
        "alpha",
      },
    },
    animation = {
      enable = false,
    },
  },
}
