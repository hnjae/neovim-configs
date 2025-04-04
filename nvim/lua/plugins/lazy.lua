local M = {}

M.setup = function()
  if require("utils").is_root then
    return
  end

  local msg
  if vim.fn.has("unix") == 0 then
    msg = "Only *nix are supported."
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  if vim.fn.has("nvim-0.8") == 0 then
    msg = "lazy.nvim requires Neovim version 0.8 or higher."
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  if vim.fn.executable("git") == 0 then
    msg = "lazy.nvim requires git."
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  -- bootstrap lazy.nvim
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)
  local opts = {
    ---@type LazySpec[]
    spec = {
      { import = "plugins.core" },
      { import = "plugins.ui" },
      { import = "plugins.editing" },
      { import = "plugins.features" },
      {
        [1] = "nvim-lualine/lualine.nvim",
        optional = true,
        opts = function()
          require("plugins.core.lualine.utils.buffer-attributes"):add({
            lazy = { display_name = "Lazy", icon = "󰒲" }, -- nf-md-sleep
          })
        end,
      },
    },

    pills = require("utils").use_icons,
    performance = {
      -- NOTE: nix를 사용할 경우, 시스템의 packpath를 사용할 것. <??>
      -- NOTE: -> treesitter 이슈로 더 이상 시스템의 packpath를 사용하지 않음 <2023-11-24>
      reset_packpath = true,
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    concurrency = 12,
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  }

  if not vim.g.vscode then
    table.insert(opts.spec, { import = "plugins.filetypes" })
  end

  require("lazy").setup(opts)
end

return M
