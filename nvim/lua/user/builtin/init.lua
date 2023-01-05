local M = {}

-- vim.fn.globpath(vim.o.runtimepath, 'lua/user/set-plugin/settings/*.lua', false, true)

M.setup = function()
  local paths = vim.fn.uniq(
      vim.fn.sort(
        vim.fn.globpath(
        vim.fn.stdpath('config'), 'lua/user/builtin/settings/*.lua', false, true)
      )
    )
  for _, file in pairs(paths) do
    -- TODO: use `require` <2023-01-05, Hyunjae Kim>
    vim.cmd('source ' .. file)
  end
end

return M
