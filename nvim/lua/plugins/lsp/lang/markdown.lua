local M = {}

-- TODO: modifiable 이 off 일 때는 활성화 금지 <2023-12-28>

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    -- provides grammar and spelling errors in markup documents (LaTeX, Markdown, etc.). The documents are checked with LanguageTool.
    -- NOTE: ltex 이거 한글 잘 못다룸. class을 이라고 적어 있으면 에러 발생. <2024-01-09>
    -- ["ltex-ls"] = {
    --   "ltex",
    --   vim.tbl_deep_extend("keep", { filetypes = { "markdown" } }, opts),
    -- },
    ["marksman"] = { "marksman", opts },
  }

  for exe, val in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[val[1]].setup(val[2])
    end
  end
end

M.get_null_ls_sources = function(null_ls, _)
  local ret = {}

  local mapping = {
    -- english prose linter
    proselint = {
      null_ls.builtins.diagnostics.proselint.with({
        filetypes = { "markdown" },
      }),
    },
    -- english prose linter
    wirte_good = {
      null_ls.builtins.diagnostics.write_good.with({
        filetypes = { "markdown" },
      }),
    },
    -- spelling, grammar
    textidote = {
      null_ls.builtins.diagnostics.textidote.with({
        filetypes = { "markdown" },
      }),
    },
    -- markdownlint = { null_ls.builtins.diagnostics.markdownlint },

    -- format codeblocks inside markdown
    cbfmt = {
      null_ls.builtins.formatting.cbfmt.with({
        filetypes = { "markdown" },
      }),
    },
  }

  local opts = { filetypes = { "markdown" } }
  local formatter = {
    -- 우선 순위 높음
    -- { "mdformat", null_ls.builtins.formatting.mdformat.with(opts) },
    { "prettier", null_ls.builtins.formatting.prettier.with(opts) },
    { "prettierd", null_ls.builtins.formatting.prettierd.with(opts) },
    { "deno", null_ls.builtins.formatting.deno_fmt.with(opts) },
    -- 우선 순위 낮음
  }
  for _, source in pairs(formatter) do
    if vim.fn.executable(source[1]) == 1 then
      table.insert(ret, source[2])
      break
    end
  end

  for exe, sources in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      for _, source in pairs(sources) do
        table.insert(ret, source)
      end
    end
  end

  return ret
end

return M
