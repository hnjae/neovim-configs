-- cmp
-- TODO: nvim-autopair <2023-01-05, Hyunjae Kim>

local cmp_config = function()
  local cmp = require("cmp")

  local cmp_opts = {
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      -- ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      -- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources(
      {
        { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'snippy' }, -- For snippy users.
        -- { name = 'orgmode' },
      },
      { { name = 'nvim_lsp' }, },
      { { name = 'buffer' }, },
      { { name = 'path' } }
    ),
  }

  local has_lspkind, lspkind = pcall(require, "lspkind")
  if has_lspkind then
    cmp_opts["formatting"] = {
      format = lspkind.cmp_format({
        mode = 'symbol',
      })
    }
  end

  cmp.setup(cmp_opts)

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(
    ':',
    {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        { { name = 'path' } },
        { { name = 'cmdline' } }
      )
    }
  )

  -- Setup lspconfig.
  -- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --   capabilities = capabilities
  -- }
end

return {
  { 'hrsh7th/cmp-nvim-lsp', dependenceis = { 'hrsh7th/nvim-cmp' }},
  { 'hrsh7th/cmp-path', dependenceis = { 'hrsh7th/nvim-cmp' } },
  { 'hrsh7th/cmp-buffer', dependenceis = { 'hrsh7th/nvim-cmp' } },
  { 'hrsh7th/cmp-cmdline', dependenceis = { 'hrsh7th/nvim-cmp' } },
  { 'hrsh7th/cmp-nvim-lua', dependenceis = { 'hrsh7th/nvim-cmp' } },
  {
    'quangnguyen30192/cmp-nvim-ultisnips',
    dependenceis = {
      'hrsh7th/nvim-cmp',
      'sirver/ultisnips'
    }
  },
  { 'hrsh7th/nvim-cmp', config=cmp_config },
}
