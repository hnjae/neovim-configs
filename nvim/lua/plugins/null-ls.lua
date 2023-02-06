return {
  "jose-elias-alvarez/null-ls.nvim",
  lazy = false,
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/CONFIG.md
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
  opts = function()
    local null_ls = require("null-ls")
    local opts = {
      diagnostics_format = "#{m} (#{s})",
      -- diagnostics_format = "[#{c}] #{m} (#{s})",
      sources = {
        -- null_ls.builtins.completion.spell,
        -- null_ls.builtins.completion.tags,
        -- null_ls.builtins.diagnostics.cspell,
        -- null_ls.builtins.diagnostics.eslint,
        -- null_ls.builtins.code_actions.cspell,

        -- kotlin
        null_ls.builtins.formatting.ktlint,
        null_ls.builtins.diagnostics.ktlint,

        -- "sh"
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.hover.printenv,
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.dotenv_linter,
        -- null_ls.builtins.formatting.shellharden,

        -- zsh
        null_ls.builtins.diagnostics.zsh,
        null_ls.builtins.formatting.beautysh.with({ filetypes = { "zsh" } }),

        -- sqlfluff
        null_ls.builtins.diagnostics.sqlfluff,
        null_ls.builtins.formatting.sqlfluff,

        -- lua
        null_ls.builtins.diagnostics.selene.with({
          -- condition = function(utils)
          --   return utils.root_has_file({ "selene.toml" })
          -- end,
        }),
        null_ls.builtins.formatting.stylua,

        -- python
        null_ls.builtins.formatting.ruff, -- sort imports
        null_ls.builtins.formatting.black, -- format code
        null_ls.builtins.diagnostics.mypy.with({
          diagnostics_format = "[#{s}] #{m}",
        }),
        null_ls.builtins.diagnostics.ruff.with({
          diagnostics_postprocess = function(diagnostic)
            diagnostic.message = "["
              .. diagnostic.code
              .. "] "
              .. diagnostic.message
              .. " ("
              .. diagnostic.source
              .. ")"
            local severity = diagnostic.severity
            if diagnostic.code == "E902" or diagnostic.code == "E999" then
              severity = vim.diagnostic.severity.ERROR
            else
              severity = vim.diagnostic.severity.WARN
              -- -- TODO: this is dirty <2023-01-27, Hyunjae Kim>
              -- local code_1 = diagnostic.code:sub(1, 1)
              -- if code_1 == "I" or code_1 == "Q" or diagnostic.code:sub(1, 3) == "COM" then
              --   severity = vim.diagnostic.severity.HINT
              -- else
              -- end
            end
            diagnostic.severity = severity
          end,
        }),
      },
      root_dir = require("null-ls.utils").root_pattern(
        ".neoconf.json",
        ".editorconfig",
        "pyproject.toml",
        "vim.toml",
        "selene.toml",
        ".nlsp-settings",
        ".git"
      ),
    }

    return opts
  end,
}