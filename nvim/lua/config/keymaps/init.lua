-- vim:foldmethod=marker:foldlevel=0:

-- docs: map-table

local M = {}
local package_path = (...)
M.setup = function()
  local prefix = require("globals").prefix
  local map_keyword = require("globals").map_keyword

  if vim.fn.has("gui_running") == 1 then
    -- TODO: neovide 에서 아래가 잘 작동하는지 테스트, cmdline 에서도 동작해야함. <2024-08-02>
    vim.keymap.set({ "n" }, "<C-S-v>", '"+p', { desc = "paste" })
  end

  --------------------------------------------------------------------------------
  -- leader & localleader
  --------------------------------------------------------------------------------
  vim.g.mapleader = " "
  -- NOTE: , : repeat t/T/f/F backwards
  -- NOTE: s : almost same as c

  -- disable s/S, use c/0C instead
  -- NOTE: do not include selection mode here <2023-07-20>
  vim.keymap.set({ "n", "x", "o" }, "s", "<Nop>", { noremap = true })
  -- vim.keymap.set({ "n", "x", "o" }, "S", "<Nop>", { noremap = true })

  -- vim.g.maplocalleader = "\\"
  vim.g.maplocalleader = "s"
  --[[
  NOTE:
  "s" 가 "LocalLeader" 인 경우, vim.o.timeoutlen 이 충분해야 단축키가 작동한다.
  timeoutlen 이 지나버리면, s 에 맵핑된 키맵이 바로 작동되어 버리기 때문.
  <2024-07-17>
  ]]
  --------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- leader & localleader
  --------------------------------------------------------------------------------
  vim.keymap.set({ "n", "v" }, "<Leader><Leader>", ":", { desc = "cmdline" })
  -- vim.keymap.set({ "n", "x", "s" }, ":", "<Nop>") -- disable default behavior
  vim.keymap.set({ "n" }, "<F3>", "<cmd>wa<CR>", { desc = "write-all" })
  -- vim.keymap.set("n", "<C-s>", "<cmd>wa<CR>", { desc = "write-all" })

  --------------------------------------------------------------------------------
  -- {{{ buffer
  --------------------------------------------------------------------------------
  vim.keymap.set({ "n" }, "gb", "<cmd>bnext<CR>", { desc = "next-buffer" })
  vim.keymap.set({ "n" }, "gB", "<cmd>bprevious<CR>", { desc = "prev-buffer" })

  -- }}}
  --------------------------------------------------------------------------------
  -- {{{ fold
  --------------------------------------------------------------------------------
  vim.keymap.set({ "n" }, "<LocalLeader>d", "za", { desc = "fold-toggle" })
  vim.keymap.set({ "n" }, "<LocalLeader>D", "zO", { desc = "open-all-fold" })

  vim.keymap.set({ "n" }, "za", "<Nop>")
  vim.keymap.set({ "n" }, "zA", "<Nop>")
  vim.keymap.set({ "n" }, "zo", "<Nop>")
  vim.keymap.set({ "n" }, "zO", "<Nop>")
  vim.keymap.set({ "n" }, "zc", "<Nop>")
  vim.keymap.set({ "n" }, "zC", "<Nop>")

  -- close-all
  vim.keymap.set({ "n" }, "zm", "<Nop>")
  vim.keymap.set({ "n" }, "zM", "<Nop>")
  -- open-all
  -- vim.keymap.set({ "n" }, "zr", "<Nop>")
  -- vim.keymap.set({ "n" }, "zR", "<Nop>")

  -- }}}
  --------------------------------------------------------------------------------
  -- {{{ handy emacs-like behavior
  --------------------------------------------------------------------------------
  vim.keymap.set({ "i" }, "<C-e>", "<C-\\><C-n>A")
  vim.keymap.set({ "i" }, "<C-a>", "<C-\\><C-n>I")
  -- }}}
  --------------------------------------------------------------------------------
  -- {{{ escape teriminal/mapping (WIP)
  --------------------------------------------------------------------------------
  vim.keymap.set(
    { "t" },
    "<S-Esc>",
    "<C-\\><C-n>",
    { desc = "escape-terminal" }
  )
  vim.keymap.set(
    { "i", "t" },
    "<C-e>",
    "<C-\\><C-n>",
    { desc = "escape-terminal" }
  )
  -- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], {})
  -- }}}
  --------------------------------------------------------------------------------
  -- {{{ open new page with current buffer
  --------------------------------------------------------------------------------
  -- vim.keymap.set({ "n" }, prefix.new .. "c", "", { desc = "+current" })
  vim.keymap.set(
    { "n" },
    prefix.new .. "c" .. map_keyword.vsplit,
    "<cmd>vsplit<CR>",
    { desc = "vsplit" }
  )
  vim.keymap.set(
    { "n" },
    prefix.new .. "c" .. map_keyword.split,
    "<cmd>split<CR>",
    { desc = "split" }
  )
  vim.keymap.set(
    { "n" },
    prefix.new .. "c" .. map_keyword.tab,
    "<cmd>tabedit %<CR>",
    { desc = "tab" }
  )

  -- open new page with an empty window
  vim.keymap.set(
    { "n" },
    prefix.new .. "e" .. map_keyword.vsplit,
    "<cmd>vnew<CR>",
    { desc = "vsplit" }
  )
  vim.keymap.set(
    { "n" },
    prefix.new .. "e" .. map_keyword.split,
    "<cmd>new<CR>",
    { desc = "split" }
  )
  vim.keymap.set(
    { "n" },
    prefix.new .. "e" .. map_keyword.tab,
    "<cmd>tabedit<CR>",
    { desc = "tab" }
  )
  -- }}}
  --------------------------------------------------------------------------------
  -- {{{ close things
  --------------------------------------------------------------------------------
  -- vim.keymap.set(
  --   "n",
  --   prefix.close .. "b",
  --   "<cmd>bd<CR>",
  --   { desc = "buffer-delete" }
  -- )
  vim.keymap.set(
    "n",
    prefix.close .. "QA",
    "<cmd>qa<CR>",
    { desc = "quit-all" }
  )
  vim.keymap.set(
    "n",
    prefix.close .. "`",
    "<cmd>delmarks!<CR>",
    { desc = "delete-all-lowcass-mark" }
  )
  vim.keymap.set(
    "n",
    prefix.close .. "h",
    "<cmd>nohlsearch<CR>",
    { desc = "no-highlight-search" }
  )
  -- vim.keymap.set("n", prefix.close .. "s", "<cmd>luafile $MYVIMRC<CR>", { desc = "source $MYVIMRC" })
  -- }}}
  --------------------------------------------------------------------------------
  -- {{{ clipboard
  --------------------------------------------------------------------------------
  -- stylua: ignore start
  vim.keymap.set( { "n", "x", "s" }, "<F12>",   [["+y]], { desc = "yank-to-clipboard" } )
  vim.keymap.set( { "n", "v", "s" }, "<S-F12>", [["+p]], { desc = "paste-from-clipboard" })
  -- stylua: ignore end
  -- }}}
  --------------------------------------------------------------------------------
  -- {{{  misc
  vim.keymap.set(
    { "n" },
    "<S-F5>",
    ":source $MYVIMRC<CR>",
    { desc = "resource init.lua" }
  )
  -- }}}
  --------------------------------------------------------------------------------
  -- vim.keymap.set({"n", "t"}, "<left>", "<cmd>wincmd h<CR>")
  -- vim.keymap.set({"n", "t"}, "<down>", "<cmd>wincmd j<CR>")
  -- vim.keymap.set({"n", "t"}, "<up>", "<cmd>wincmd k<CR>")
  -- vim.keymap.set({"n", "t"}, "<right>", "<cmd>wincmd l<CR>")
  -- vim.keymap.set("n", "<S-left>", "<C-w>H")
  -- vim.keymap.set("n", "<S-down>", "<C-w>J")
  -- vim.keymap.set("n", "<S-up>", "<C-w>K")
  -- vim.keymap.set("n", "<S-right>", "<C-w>L")
  --------------------------------------------------------------------------------
  -- NOTE: VS Code Mapping:
  -- https://code.visualstudio.com/shortcuts/keyboard-shortcuts-Linux.pdf

  for _, package in
    ipairs(require("utils").get_packages(package_path .. ".setups"))
  do
    package.setup()
  end
end

return M
