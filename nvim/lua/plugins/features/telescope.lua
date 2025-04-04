---@type LazySpec
return {
  [1] = "nvim-telescope/telescope.nvim",
  enabled = true,
  cond = not vim.g.vscode,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      [1] = "nvim-telescope/telescope-fzf-native.nvim",
      build = vim.fn.executable("make") == 1 and "make" or table.concat({
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release &&",
        "cmake --build build --config Release &&",
        "cmake --install build --prefix build",
      }, " "),
      enabled = (
        vim.fn.executable("make") == 1 and vim.fn.executable("cc") == 1
      ) or vim.fn.executable("cmake") == 1,

      config = function()
        require("utils.plugin").on_load("telescope.nvim", function()
          require("telescope").load_extension("fzf")
        end)
      end,
    },
    -- {
    --   [1] = "nvim-telescope/telescope-frecency.nvim",
    --   config = function()
    --     require("utils.plugin").on_load("telescope.nvim", function()
    --       require("telescope").load_extension("frecency")
    --     end)
    --   end,
    -- },
    {
      -- replace vim.ui.select with telescope
      [1] = "nvim-telescope/telescope-ui-select.nvim",
      enabled = false,
      config = function()
        require("utils.plugin").on_load("telescope.nvim", function()
          require("telescope").load_extension("ui-select")
        end)
      end,
    },
  },
  lazy = true,
  -- TODO: find appropriate event that calls vim.ui.select()
  event = { "CmdLineEnter", "MenuPopup" },
  cmd = {
    "Telescope",
  },
  ---@type fun(LazyPlugin, keys: LazyKeysSpec[]): nil
  keys = function(_, keys)
    local globals = require("globals")
    local prefix = globals.prefix
    local map_keyword = globals.map_keyword
    local t_builtin = require("telescope.builtin")
    local _, lspconfig = pcall(require, "lspconfig")
    local prefix_search_in_buffer = "<LocalLeader>" .. map_keyword.find

    local find_project_root =
      lspconfig.util.root_pattern(unpack(globals.root_patterns))

    ---@param ft? string filtepye
    local get_cwd = function(ft)
      if ft == "oil" then
        return require("oil").get_current_dir()
      end

      if ft == "netrw" then
        return vim.api.nvim_buf_get_var(0, "netrw_curdir")
      end

      return vim.fn.expand("%:p:h")
    end

    ---@type LazyKeysSpec[]
    local lazykeys = {
      -- stylua: ignore start
      -- replace default behavior

      -- NOTE: help is only available when plugin is loaded. 아니라면 E661 Sorry, no 'en' help ... 메시지 뜰 것. <2025-03-25>
      { [1] = "<F1>", [2] = t_builtin.help_tags, desc = "help-tags" },
      { [1] = "<F1>", [2] = t_builtin.help_tags, desc = "help-tags", ft= "netrw" },

      { [1] = prefix.find .. "0", [2] = "<cmd>Telescope<CR>", desc = "builtins" },
      { [1] = prefix.find .. "R", [2] = t_builtin.registers,  desc = "registers" },
      { [1] = prefix.find .. "q", [2] = t_builtin.quickfix,   desc = "quickfix" },

      -- +history
      { [1] = prefix.find .. "h",  [2] = nil,                       desc = "+history" },
      { [1] = prefix.find .. "hc", [2] = t_builtin.command_history, desc = "command-history" },
      { [1] = prefix.find .. "hs", [2] = t_builtin.search_history,  desc = "search-history" },
      { [1] = prefix.find .. "hk", [2] = t_builtin.keymaps,         desc = "keymaps-history" },
      { [1] = prefix.find .. "hf", [2] = t_builtin.oldfiles,        desc = "oldfiles-history" },
      -- stylua: ignore end


      -- stylua: ignore start
      { [1] = prefix_search_in_buffer .. map_keyword.marks,   [2] = t_builtin.marks,                     desc = "marks" },
      { [1] = prefix_search_in_buffer .. map_keyword.line,    [2] = t_builtin.current_buffer_fuzzy_find, desc = "line" },

      -- stylua: ignore end
    }
    vim.list_extend(keys, lazykeys)

    -- symbols
    table.insert(keys, {
      [1] = prefix_search_in_buffer .. map_keyword.symbols,
      [2] = t_builtin.treesitter,
      desc = "symbols (treesitter)",
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        local keymap_opts = { buffer = args.buf }
        local mappings = {
          ["textDocument/documentSymbol"] = {
            lhs = prefix_search_in_buffer .. map_keyword.symbols,
            rhs = t_builtin.lsp_document_symbols,
            desc = "symbols (lsp)",
          },
          ["workspace/symbol"] = {
            lhs = prefix_search_in_buffer .. string.upper(map_keyword.symbols),
            rhs = t_builtin.lsp_workspace_symbols,
            desc = "workspace-symbols (lsp)",
          },
          ["textDocument/definition"] = {
            lhs = prefix_search_in_buffer .. "d",
            rhs = t_builtin.lsp_definitions,
            desc = "definition (lsp)",
          },
          ["textDocument/implementation"] = {
            lhs = prefix_search_in_buffer .. "m",
            rhs = t_builtin.lsp_implementations,
            desc = "implementation (lsp)",
          },
          ["callHierarchy/incomingCalls"] = {
            lhs = prefix_search_in_buffer .. "i",
            rhs = t_builtin.lsp_incoming_calls,
            desc = "incoming-calls (lsp)",
          },
          ["callHierarchy/outgoingCalls"] = {
            lhs = prefix_search_in_buffer .. "o",
            rhs = t_builtin.lsp_outgoing_calls,
            desc = "outgoing-calls (lsp)",
          },
          ["textDocument/typeDefinition"] = {
            lhs = prefix_search_in_buffer .. "p",
            rhs = t_builtin.lsp_type_definitions,
            desc = "type-definition (lsp)",
          },
        }
        for method, specs in pairs(mappings) do
          if client.supports_method(method) then
            for _, spec in ipairs(specs.desc and { specs } or specs) do
              vim.keymap.set(
                spec.mode and spec.mode or "n",
                spec.lhs,
                spec.rhs,
                vim.tbl_extend("error", keymap_opts, { desc = spec.desc })
              )
            end
          end
        end
      end,
    })

    ---------------------------------------------------------------------------
    local new_win_presets = {
      {
        key = "f",
        desc = "find-files",
        func = function()
          t_builtin.find_files({
            cwd = find_project_root(get_cwd(vim.bo.filetype)),
          })
        end,
      },
      {
        key = "F",
        desc = "find-files-cwd",
        func = function()
          t_builtin.find_files({ cwd = get_cwd(vim.bo.filetype) })
        end,
      },
      {
        key = "b",
        desc = "buffers",
        func = function()
          t_builtin.buffers({
            sort_mru = true,
            show_all_buffers = true,
            -- cwd = find_project_root(get_cwd(vim.bo.filetype)),
          })
        end,
      },
      {
        key = "r",
        desc = "rg",
        func = function()
          -- NOTE: live_grep does not uses fzf <https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/65> <2025-03-25>
          t_builtin.grep_string({
            cwd = find_project_root(get_cwd(vim.bo.filetype)),
            search = "", -- do not grep string from cursor/visual
          })
        end,
      },
      {
        key = "R",
        desc = "rg-cwd",
        func = function()
          t_builtin.grep_string({
            cwd = get_cwd(vim.bo.filetype),
            search = "", -- do not grep string from cursor/visual
          })
        end,
      },
    }

    for _, preset in pairs(new_win_presets) do
      local new_keysets = {
        {
          [1] = prefix.find .. preset.key,
          [2] = preset.func,
          desc = preset.desc,
        },
      }
      vim.list_extend(keys, new_keysets)
    end
  end,
  opts = function()
    local map_keyword = require("globals").map_keyword

    local ret = {
      defaults = {
        history = {
          path = require("plenary.path"):new(
            vim.fn.stdpath("state"),
            "treesitter-history"
          ).filename,
        },
        mappings = {
          i = {
            [string.format("<C-%s>", map_keyword.split)] = "select_horizontal",
            -- ["<C-x>"] = nil,
          },
          n = {
            -- [string.format("<C-%s>", map_keyword.split)] = "select_horizontal",
            -- ["<C-x>"] = nil,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = {
            "fd",
            "--hidden",
            -- "--type",
            -- "f",
            "--strip-cwd-prefix",
            -- "--ignore-vcs",
            "-E",
            "node_modules",
            "-E",
            ".git",
            "-E",
            ".direnv",
          },
        },
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
      },
    }

    return ret
  end,
  ---@type fun(LazyPlugin, opts: table)
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
  end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        local icons = require("globals").icons
        require("plugins.core.lualine.utils.buffer-attributes"):add({
          TelescopePrompt = {
            display_name = "TelescopePrompt",
            icon = icons.search,
          },
        })
      end,
    },
  },
}
