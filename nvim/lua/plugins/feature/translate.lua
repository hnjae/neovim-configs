---@type LazySpec
return {
  [1] = "uga-rosa/translate.nvim",
  lazy = true,
  enabled = true,
  cmd = {
    "Translate",
  },
  opts = {
    default = {
      -- command = "deepl_pro",
      output = "split",
    },
    preset = {
      output = {
        split = {
          append = true,
        },
      },
    },
  },
}
