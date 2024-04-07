local prefix = require("val").prefix
local map_keyword = require("val").map_keyword
local prefix_send = prefix.toggleterm_send

---@type LazySpec
return {
  [1] = "akinsho/toggleterm.nvim",
  version = "*",
  lazy = true,
  cond = os.getenv("NVIM") == nil, -- toggleterm 안의 nvim 안의 toggerterm 금지.
  cmd = {
    "ToggleTerm",
    "ToggleTermToggleAll",
    "TermExec",
    "TermSelect",
    "ToggleTermSendCurrentLine",
    "ToggleTermSendVisualLines",
    "ToggleTermSendVisualSelection",
    -- 'ToggleTermSetName',
  },
  opts = {
    open_mapping = [[<F4>]],
    shell = os.getenv("SHELL") or vim.o.shell,
    -- direction = "float",
    direction = "horizontal",
    shade_terminals = false,
  },
  ---@type LazyKeysSpec[]
  keys = {
    { [1] = "<F4>", [2] = nil, desc = "toggleterm" },
    {
      [1] = prefix_send .. "l",
      [2] = "<cmd>ToggleTermSendCurrentLine<CR>",
      mode = { "n" },
      desc = "send-line",
    },
    -- { prefix .. "b", ":<C-u>%>ToggleTermSendCurrentLine<CR>", mode = { "n" }, desc = "send-buffer" },
    {
      [1] = prefix_send .. "b",
      [2] = "<C-\\><C-n>ggVG:<C-u>'<,'>ToggleTermSendVisualLines<CR>",
      mode = { "n" },
      desc = "send-buffer",
    },
    {
      [1] = prefix_send .. "l",
      [2] = ":<C-u>'<,'>ToggleTermSendVisualLines<CR>",
      mode = { "x" },
      desc = "send-visual-lines",
    },
    {
      [1] = prefix_send .. "s",
      [2] = ":<C-u>'<,'>ToggleTermSendVisualSelection<CR>",
      mode = { "x" },
      desc = "send-visual-selection",
    },
    { [1] = prefix.new .. map_keyword.terminal, [2] = nil, desc = "+terminal" },
    {
      [1] = prefix.new .. map_keyword.terminal .. map_keyword.vsplit,
      [2] = function()
        local term = require("toggleterm.terminal").Terminal:new({
          direction = "vertical",
        })
        term:open()
      end,
      mode = { "n" },
      desc = "v-split",
    },
    {
      [1] = prefix.new .. map_keyword.terminal .. map_keyword.split,
      [2] = function()
        local term = require("toggleterm.terminal").Terminal:new({
          direction = "horizontal",
        })
        term:open()
      end,
      mode = { "n" },
      desc = "h-split",
    },
    {
      [1] = prefix.new .. map_keyword.terminal .. map_keyword.tab,
      [2] = function()
        local term = require("toggleterm.terminal").Terminal:new({
          direction = "tab",
        })
        term:open()
      end,
      mode = { "n" },
      desc = "tab",
    },
    {
      [1] = prefix.new .. map_keyword.terminal .. map_keyword.float,
      [2] = function()
        local term = require("toggleterm.terminal").Terminal:new({
          direction = "float",
        })
        term:open()
      end,
      mode = { "n" },
      desc = "float",
    },
    {
      [1] = prefix.sidebar .. map_keyword.terminal,
      [2] = function()
        local terminals = require("toggleterm.terminal").get_all()
        if #terminals <= 1 then
          vim.cmd("ToggleTerm")
        else
          vim.cmd("TermSelect")
        end
      end,
      mode = { "n" },
      desc = "terminal",
    },
    {
      [1] = prefix.finder .. map_keyword.terminal,
      [2] = "<cmd>TermSelect<CR>",
      mode = { "n" },
      desc = "terminal",
    },
    -- {
    --   [1] = prefix.focus .. map_keyword.terminal,
    --   [2] = function()
    --     local len_winnr = vim.fn.winnr("$")
    --
    --     -- 이미 terminal buffer 에 focus 중일 경우
    --     if
    --       vim.fn.getbufinfo(vim.fn.bufnr())[1]["variables"]["terminal_job_id"]
    --     then
    --       local last_winnr = vim.t._last_toggleterm_winnr or 1
    --       last_winnr = last_winnr > len_winnr and 1 or last_winnr
    --       vim.cmd(string.format([[exe %d .. "wincmd w"]], last_winnr))
    --       return
    --     end
    --
    --     --
    --     for winnr = 0, (len_winnr - 1) do
    --       winnr = len_winnr - winnr
    --       if
    --         vim.fn.getbufinfo(vim.fn.winbufnr(winnr))[1]["variables"]["terminal_job_id"]
    --       then
    --         vim.t._last_toggleterm_winnr = vim.fn.winnr()
    --         vim.cmd(string.format([[exe %d .. "wincmd w"]], winnr))
    --         return
    --       end
    --     end
    --
    --     local terms = require("toggleterm.terminal").get_all()
    --     -- for _, term in ipairs(terms) do
    --     --   if term:is_open() then
    --     --     term:focus()
    --     --     return
    --     --   end
    --     -- end
    --
    --     -- 만약 열려있는 터미널이 없을 경우
    --     if #terms <= 1 then
    --       vim.cmd("ToggleTerm")
    --     else
    --       vim.cmd("TermSelect")
    --     end
    --   end,
    --   mode = { "n" },
    --   desc = "focus toggerterm",
    -- },

    -- TODO: visual 이랑 selection 이랑 뭐가 달라? <2023-02-15>
    -- visual 서 lazy 랑 같이 쓰려면 <cmd>로는 안된다.
  },
}
