-- modules sourced by several plugins

---@type LazySpec[]
return {
  {
    [1] = "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    [1] = "kkharji/sqlite.lua",
    lazy = true,
    enabled = vim.fn.executable("sqlite3") == 1,
  },
  {
    [1] = "MunifTanjim/nui.nvim",
    lazy = true,
  },
}
