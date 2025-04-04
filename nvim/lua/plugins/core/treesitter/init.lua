local disable = function(lang, bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > 20000
end

---@type LazySpec
local M = {
  [1] = "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  enabled = require("utils").is_treesitter,
  event = { "VeryLazy" }, -- { "BufReadPost", "BufNewFile" },
  -- init = function() end,
  opts = function(_, opts)
    local default = {
      sync_install = false,
      auto_install = false,
      ignore_install = {},
      highlight = {
        enable = true,
        disable = disable,
        additional_vim_regex_highlighting = false,
        -- disable = function(lang, buf)
        --   vim.notify(lang)
        --   local max_filesize = 100 * 1024 -- 100 KB
        --   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --   if ok and stats and stats.size > max_filesize then
        --     return true
        --   end
        -- end,
      },
      indent = {
        enable = true, -- NOTE: experimental features <2023-11-23>
        disable = {},
      },
      incremental_selection = {
        enale = false,
        disable = disable,
      },
    }

    return vim.tbl_deep_extend("keep", default, opts)
  end,
  main = "nvim-treesitter.configs",
  config = function(plugin, opts)
    require("plugins.core.treesitter.languages"):add(
      --
      "diff",
      "comment",
      "dot",
      "regex",
      --
      "awk",
      "jq",
      --
      "ssh_config",
      "gpg",
      "udev"
    )
    opts.ensure_installed = require("plugins.core.treesitter.languages"):get_list()
    require(plugin.main).setup(opts)

    local del_commands = {
      "TSEditQuery",
      "TSEditQueryUserAfter",
    }
    for _, command in ipairs(del_commands) do
      vim.api.nvim_del_user_command(command)
    end

    -- TODO: fold 를 지원하는 filetype 만 아래를 바꾸기 <2025-04-02>
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  end,
  specs = {
    {
      [1] = "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = {
        {
          [1] = "ray-x/cmp-treesitter",
          dependencies = "nvim-treesitter/nvim-treesitter",
        },
      },
      ---@param opts myCmpOpts
      opts = function(_, opts)
        local cmp = require("cmp")
        opts.sources = opts.sources or {}

        table.insert(
          opts.sources,
          1,
          { name = "treesitter", group_index = 1, max_item_count = 8 }
        )

        opts.cmdline_search_sources = vim.list_extend(
          opts.cmdline_search_sources or {},
          cmp.config.sources({
            { name = "treesitter" },
          })
        )
      end,
    },
  },
}

return M
