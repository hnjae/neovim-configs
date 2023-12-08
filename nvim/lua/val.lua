local M = {}

-- this prefix will be registered by which.key
M.prefix = {
  lang = "s",
  close = "Z",

  finder = "<F3>",
  sniprun = "<Leader>r",
  focus = "<Leader>f",
  repl = "<Leader>r",
  sidebar = "<Leader>s",

  ["toggleterm-send"] = "<Leader>t",

  tab = "<Leader>nt",
  -- window = "<Leader>nw",
  edit = "<Leader>ne",
  vsplit = "<Leader>nv",
  split = "<Leader>ns",

  open = "<F6>",
}

-- TODO: root_patterns을 각 언어별로 구분해서 선언할 것 <2023-05-18>
-- null-ls 가 잘 지원하는지 모르겠다.
M.root_patterns = {
  ".git",
  ".editorconfig",
  ".neoconf.json",
  ".nlsp-settings",
  "flake.nix",
  ".envrc",
}

M.root_patterns2 = {
  python = {
    "pyproject.toml",
  },
  lua = {
    "selene.toml",
    "stylua.toml",
  },
  typescript = {
    "tsconfig.json",
  },
  ["_"] = {
    ".nlsp-settings",
    ".neoconf.json",
    ".editorconfig",
    -- ".envrc",
    ".git",
  },
}

-- on_attach function for lspconfig and null-ls
M.on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  vim.keymap.set("n", "==", function()
    vim.lsp.buf.format({ async = true })
  end, { desc = "lsp-format", buffer = bufnr })

  vim.keymap.set("v", "==", function()
    vim.lsp.buf.format({
      async = true,
      range = {
        ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
        ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
      },
    })
  end, { desc = "lsp-buf-format", buffer = bufnr })
end

return M