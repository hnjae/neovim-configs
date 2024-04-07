-- It's important that you set up neoconf.nvim BEFORE nvim-lspconfig.

---@type LazySpec
return {
  [1] = "folke/neoconf.nvim",
  lazy = true,
  event = { "VeryLazy" },
  enabled = require("utils").is_treesitter,
  opts = {
    local_settings = ".neoconf.jsonc",
    global_settings = "neoconf.jsonc",
    import = {
      vscode = false,
      coc = false,
      nlsp = false,
    },

    -- requires treesitter's jsonc parser installed
    filetype_jsonc = true,
  },
}
