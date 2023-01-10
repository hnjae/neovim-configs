return {
  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function()
      -- local config = {
      --   toggler = {
      --     bblock = 'gBc'
      --   },
      --
      --   opleader = {
      --       ---Block-comment keymap
      --       block = 'gB',
      --   },
      -- }
      -- vim.cmd([[
      -- nmap gb ""
      -- ]])
      require("Comment").setup()
    end
  },
  {
    'ntpeters/vim-better-whitespace',
    lazy = false,
    cond = function()
      vim.g.strip_whitespace_on_save = 1
      vim.g.strip_whitelines_at_eof = 1

      vim.g.strip_whitespace_confirm = 0
      vim.g.strip_max_file_size = 10000

      -- 공백을 칠하는것 금지.
      vim.g.better_whitespace_enabled = 0
      vim.g.show_spaces_that_precede_tabs = 0

      -- vim.g.better_whitespace_ctermcolor = 'bg'
      -- vim.g.better_whitespace_guicolor = 'bg'
      -- let g:current_line_whitespace_disabled_soft

      -- exclude markdown from blacklists
      vim.g.better_whitespace_filetypes_blacklist = {
        'diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'fugitive'
      }

      -- disable mappings
      vim.g.better_whitespace_operator = ""
    end
  },
  {
    "windwp/nvim-autopairs",
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      -- local n_rule = require('nvim-autopairs.rule')

      local opts = {
        -- disable_filetype = { "TelescopePrompt" },
        disable_in_macro = true, -- disable when recording or executing a macro
        disable_in_visualblock = true, -- disable when insert after visual block mode
        -- ignored_next_char = [=[[%w%%%'%[%"%.]]=],
        -- enable_moveright = true,
        -- enable_afterquote = true,  -- add bracket pairs after quote
        enable_check_bracket_line = false, --- check bracket in same line
        -- enable_bracket_in_quote = true, --
        -- break_undo = true, -- switch for basic rule break undo sequence
        check_ts = true, -- treesitter
        -- map_cr = true,  -- add indent when new line
        -- map_bs = true,  -- delete paren if BS
        -- map_c_h = false,  -- Map the <C-h> key to delete a pair
        -- map_c_w = false, -- map <c-w> to delete a pair if possible
      }
      require("nvim-autopairs").setup(opts)
    end
  },
}