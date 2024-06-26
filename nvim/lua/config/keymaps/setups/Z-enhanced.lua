local M = {}

M.setup = function()
  local ignore_fts = {
    -- notify = true,
    -- noice = true,
    -- cmp_menu = true,
    -- cmp_docs = true,
  }
  local is_normal_buf = function(bufnr)
    if vim.api.nvim_buf_get_option(bufnr, "buftype") == "" then
      return true
    end

    return false
  end

  local zz_enhanced = function(mode)
    local normal_bufnrs = {}
    local abnormal_bufnrs = {}
    local winnrs = vim.api.nvim_tabpage_list_wins(vim.fn.tabpagenr())
    for _, winnr in ipairs(winnrs) do
      -- not floating
      if vim.api.nvim_win_get_config(winnr).zindex then
        goto continue
      end

      local bufnr = vim.api.nvim_win_get_buf(winnr)

      if ignore_fts[vim.api.nvim_buf_get_option(bufnr, "filetype")] then
        goto continue
      end

      if is_normal_buf(bufnr) then
        table.insert(normal_bufnrs, bufnr)
      else
        table.insert(abnormal_bufnrs, bufnr)
      end

      ::continue::
    end

    if
      is_normal_buf(0)
      and (#normal_bufnrs == 1)
      and (#abnormal_bufnrs ~= 0)
    then
      for _, bufnr in ipairs(abnormal_bufnrs) do
        if vim.api.nvim_buf_get_option(bufnr, "filetype") == "minimap" then
          vim.cmd("MinimapClose")
        else
          vim.api.nvim_buf_delete(bufnr, {})
        end
      end
    end

    -- if vim.api.nvim_buf_get_option(0, "filetype") == "minimap" then
    --   vim.cmd("MinimapClose")
    -- vim.api.nvim_set_current_win(window_id)
    if mode == "ZZ" then
      vim.cmd("x")
    elseif mode == "ZQ" then
      vim.cmd("q!")
    end
  end

  vim.keymap.set("n", "ZZ", function()
    zz_enhanced("ZZ")
  end, { desc = "ZZ-enhanced" })
  vim.keymap.set("n", "ZQ", function()
    zz_enhanced("ZQ")
  end, { desc = "ZQ-enhanced" })
end

return M
