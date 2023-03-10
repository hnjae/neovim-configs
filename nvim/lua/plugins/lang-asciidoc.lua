return {
  "habamax/vim-asciidoctor",
  lazy = false,
  -- ft = { "asciidoc", "asciidoctor" },
  keys = {
    {
      require("val").prefix.lang .. "p",
      "<cmd>AsciidoctorOpenRAW<CR>",
      desc = "preview",
    },
  },
  init = function()
    -- NOTE: handlr can not handle asciidoc file.
    -- It recognize it as text file.
    local browser = os.getenv("BROWSER")
    if browser == nil then
      browser = "firefox"
    end

    local is_luasnip, luasnip = pcall(require, "luasnip")
    if is_luasnip then
      luasnip.filetype_extend("asciidoctor", {"asciidoc"})
    end

    vim.g.asciidoctor_opener = "!" .. browser

    vim.g.asciidoctor_folding = 1
    vim.g.asciidoctor_syntax_indented = 1
    vim.g.asciidoctor_fenced_languages = {
      "html",
      "python",
      "java",
      "sh",
      "ruby",
      "dockerfile",
      "sql",
      "c",
    }
    vim.g.asciidoctor_syntax_conceal = 1
  end,
}
