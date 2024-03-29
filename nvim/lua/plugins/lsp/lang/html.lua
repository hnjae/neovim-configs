---@type LspSpec
local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    ["vscode-html-language-server"] = "html",
  }
  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

M.get_conform_opts = function()
  return {
    formatters_by_ft = {
      html = { { "prettierd", "prettier" } },
    },
  }
end

return M
