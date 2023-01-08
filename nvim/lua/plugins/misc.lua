return {
  -- vimL plugin
  -- repl/repl-like
  { 'michaelb/sniprun', lazy = true, build = 'bash ./install.sh' },
  -- run test
  { 'vim-test/vim-test', lazy = true },
  { 'vimwiki/vimwiki', lazy = true },
  { 'tpope/vim-surround' },
  { 'johngrib/vim-f-hangul' },
  { 'ap/vim-css-color' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-fugitive' },
  {
    'habamax/vim-asciidoctor',
    lazy = true,
    ft = { "asciidoc", "asciidoctor" },
    config = function()
      -- NOTE: handlr can not handle asciidoc file.
      -- It recognize it as text file.
      local browser = vim.fn.expand("$BROWSER")
      if browser == "$BROWSER" then
        browser = "firefox"
      end
      vim.g.asciidoctor_opener = "!" .. browser

      vim.g.asciidoctor_folding = 1
      vim.g.asciidoctor_fenced_languages = {
        'html', 'python', 'java', 'sh', 'ruby', "dockerfile"
      }
      vim.g.asciidoctor_syntax_conceal = 1
    end
  },
  -- language
  { 'lervag/vimtex', lazy = true, ft = { "tex" } },
  {
    'python-mode/python-mode',
    lazy = true,
    branch = 'develop',
    ft = { 'python' },
  },
  { 'rust-lang/rust.vim', lazy = true, ft = { 'rust' }, },

  -- dev
  -- { "folke/neodev.nvim" },


  -- editing experince

  -- misc
  { 'h-hg/fcitx.nvim', cond = vim.fn.executable("fcitx5-remote") },
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
      require("hop").setup { keys = 'etovxqpdygfblzhckisuran' }
    end

  },
  {
    "akinsho/toggleterm.nvim",
    tag = '2.3.0',
    lazy = false,
    config = function()
      require("toggleterm").setup()
    end
  },

  ------------------------------------------------------------------------------
  -- disabled
  ------------------------------------------------------------------------------
  {
    'junegunn/fzf.vim',
    lazy = false,
    enabled = false,
    cond = vim.fn.executable("fzf") == 1,
  },
  { 'wfxr/minimap.vim', enabled = false },
  { 'neoclide/jsonc.vim', lazy = true, enabled = false },
}
