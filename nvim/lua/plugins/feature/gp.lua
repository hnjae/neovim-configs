--[[
-- NOTE:

run `:GpInspectPlugin` to debug

run `secret-tool store --label=<api-anthropic> api anthropic` to save password

같이 보기:
  * <https://ai.google.dev/pricing>
  * <https://docs.anthropic.com/en/api/messages>
]]

---@type LazySpec
return {
  [1] = "Robitx/gp.nvim",
  lazy = true,
  event = "VeryLazy",
  dependencies = {},
  config = function(_, opts)
    require("gp").setup(opts)

    local rm_commands = {
      "GpWhisper",
      "GpWhisperRewrite",
      "GpWhisperAppend",
      "GpWhisperPrepend",
      "GpWhisperEnew",
      "GpWhisperNew",
      "GpWhisperVnew",
      "GpWhisperTabnew",
      "GpWhisperPopup",
    }
    for _, command in ipairs(rm_commands) do
      vim.api.nvim_del_user_command(command)
    end

    local icon = require("utils").enable_icon and require("val.icons").ai
      or "LLM"

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = { "GpDone" },
      callback = function(_)
        vim.notify(icon .. " : GpDone!", "info")
      end,
    })

    -- local gp_file_regex = vim.regex(".*/gp/chats/.*")
    -- vim.api.nvim_create_autocmd("BufWinEnter", {
    --   -- pattern = { "markdown" },
    --   callback = function(ev)
    --     vim.notify(vim.inspect(ev))
    --     -- local matches = gp_file_regex:match_str(ev.file)
    --     -- if matches == nil then
    --     --   -- not a gp chat file
    --     --   return
    --     -- end
    --     -- vim.opt_local.number = true
    --     -- vim.opt_local.relativenumber = true
    --   end,
    -- })
  end,
  opts = function(_, opts)
    local myopts = {
      command_prompt_prefix_template = (
        require("utils").enable_icon and require("val.icons").ai or "LLM:"
      ) .. " {{agent}} ~ ",
      chat_assistant_prefix = {
        (require("utils").enable_icon and require("val.icons").ai or "LLM:"),
        " [{{agent}}]",
      },
      chat_user_prefix = (require("utils").enable_icon and (require(
        "val.icons"
      ).textbox .. " :") or "Prompt:"),
      chat_conceal_model_params = false,
      -- chat_topic_model = "";

      chat_shortcut_new = {
        modes = { "n", "i", "v", "x" },
        shortcut = "<C-g>n",
      },
      chat_shortcut_respond = {
        modes = { "n", "i", "v", "x" },
        shortcut = "<C-g>r",
      },

      -- default_command_agent = "claude-3-5-haiku-command",
      default_command_agent = "copilot-gpt-4o-mini-command",
      default_chat_agent = "claude-3-5-sonnet-chat",

      chat_template = [[
# topic: ?

- file: {{filename}}
{{optional_headers}}
<!--
Respond : `{{respond_shortcut}}` | :{{cmd_prefix}}ChatRespond
Stop    : `{{stop_shortcut}}` | :{{cmd_prefix}}ChatStop
Delete  : `{{delete_shortcut}}` | :{{cmd_prefix}}ChatDelete.
New     : `{{new_shortcut}}` | :{{cmd_prefix}}ChatNew.

Chats are saved automatically.
-->
---

{{user_prefix}}
]],

      style_popup_max_width = 120,

      -- Keys
      openai_api_key = {
        "secret-tool",
        "lookup",
        "api",
        "openai",
      },

      providers = {
        openai = {
          disable = false,
        },
        copilot = {
          disable = false,
          -- secret = {
          --   "secret-tool",
          --   "lookup",
          --   "api",
          --   "copilot",
          -- },
          secret = {
            "bash",
            "-c",
            "cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
          },
        },
        anthropic = {
          disable = false,
          secret = {
            "secret-tool",
            "lookup",
            "api",
            "anthropic",
          },
        },
        googleai = {
          secret = {
            "secret-tool",
            "lookup",
            "api",
            "googleai",
          },
        },
        pplx = {
          secret = {
            "secret-tool",
            "lookup",
            "api",
            "pplx",
          },
        },
      },

      agents = {
        -- disable default agents
        { name = "ChatGPT4o", disable = true },
        { name = "CodeGPT4o", disable = true },
        { name = "ChatGPT4o-mini", disable = true },
        { name = "CodeGPT4o-mini", disable = true },
        { name = "ChatClaude-3-5-Sonnet", disable = true },
        { name = "CodeClaude-3-5-Sonnet", disable = true },
        { name = "ChatClaude-3-Haiku", disable = true },
        { name = "CodeClaude-3-Haiku", disable = true },
        { name = "ChatGemini", disable = true },
        { name = "CodeGemini", disable = true },
        { name = "ChatPerplexityLlama3.1-8B", disable = true },
        { name = "CodePerplexityLlama3.1-8B", disable = true },
        { name = "ChatCopilot", disable = true },
        { name = "CodeCopilot", disable = true },
        --
        {
          provider = "copilot",
          name = "copilot-gpt-4o-mini-chat",
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4o-mini", temperature = 1.0, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          provider = "copilot",
          name = "copilot-gpt-4o-mini-command",
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4o-mini", temperature = 0.8, top_p = 1, n = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        -- {
        --   provider = "openai",
        --   name = "gpt-4o-mini-chat",
        --   chat = true,
        --   command = false,
        --   model = { model = "gpt-4o-mini", temperature = 1.0 },
        --   system_prompt = require("gp.defaults").chat_system_prompt,
        -- },
        -- {
        --   provider = "openai",
        --   name = "gpt-4o-mini-command",
        --   chat = false,
        --   command = true,
        --   model = { model = "gpt-4o-mini", temperature = 0.7 },
        --   system_prompt = require("gp.defaults").code_system_prompt,
        -- },
        {
          provider = "anthropic",
          name = "claude-3-5-sonnet-chat",
          chat = true,
          command = false,
          model = {
            model = "claude-3-5-sonnet-latest",
            temperature = 0.9,
            max_token = 8192,
          },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          provider = "anthropic",
          name = "claude-3-5-haiku",
          chat = true,
          command = true,
          model = {
            model = "claude-3-5-haiku-latest",
            temperature = 0.8,
            max_token = 8192,
          },
          system_prompt = "",
        },
        {
          provider = "anthropic",
          name = "claude-3-5-haiku-command",
          chat = false,
          command = true,
          model = {
            model = "claude-3-5-haiku-latest",
            temperature = 0.8,
            max_token = 8192,
          },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        {
          provider = "googleai",
          name = "gemini-flash-8b",
          chat = false,
          command = true,
          model = {
            model = "gemini-1.5-flash-8b",
            temperature = 0.9,
            top_k = 40, -- range 0 -- 41
          },
          system_prompt = "",
        },
        {
          provider = "pplx",
          name = "pplx-small",
          chat = true,
          command = true,
          model = "llama-3.1-sonar-small-128k-online",
          system_prompt = "",
        },
      },

      hooks = {
        UnitTests = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by writing table driven unit tests for the code above."
          local agent = gp.get_command_agent("command-claude-3-5-sonnet")
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
        Proofread2 = function(gp, params)
          local template = [[```
{{selection}}
```
]]
          local agent = gp.get_command_agent("claude-3-5-haiku")
          agent.system_prompt =
            [[I want you to act as an expert proofreader capable of detecting and correcting grammatical issues in any language. The text given is sentences I wrote, and I would like you to correct any grammatical errors. In your responses, highlight the corrections clearly and provide a brief explanation for each correction if necessary. Your response should be in the same language as the input text. Do not alter the original meaning of the text.]]
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
        Proofread = function(gp, params)
          local template = [[```
{{selection}}
```
]]
          local agent = gp.get_command_agent("claude-3-5-sonnet-chat")
          agent.system_prompt =
            [[Act as a multilingual expert proofreader and grammar specialist with the following responsibilities:

Primary Tasks:
- Analyze provided text for grammatical errors, syntax issues, and structural problems
- Maintain the original meaning and intent while improving technical accuracy
- Provide corrections in the same language as the source text
- Ensure consistency in style and tone

Specific Focus Areas:
- Spelling and punctuation accuracy
- Word choice and vocabulary appropriateness
- Sentence structure and flow
- Tense consistency
]]
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
        GrammarCheck = function(gp, params)
          local template = [[```
{{selection}}
```
]]
          local agent = gp.get_command_agent("claude-3-5-haiku")
          agent.system_prompt =
            [[Act as a multilingual grammar specialist with the following responsibilities:

Primary Tasks:
- Analyze provided text for grammatical errors, syntax issues
- Provide corrections in the same language as the source text
- Reply the correction and nothing else, do not write explanations.
]]
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
        EnglishTranslate = function(gp, params)
          local template = [[```
{{selection}}
```
]]
          local agent = gp.get_command_agent("claude-3-5-haiku")
          agent.system_prompt =
            [[I want you to act as an English translator, spelling corrector and improver. The given text is sentences I roughly wrote, and I would like you to translate it and answer in the corrected and improved version of my text, in English. You should ensure the sentences are simple and easy to understand for non-native English speakers. Hence, avoid complex vocabulary and sentence structures. I want you to only reply the correction, the improvements and nothing else, do not write explanations.]]
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
      },
    }

    vim.tbl_deep_extend("keep", myopts, opts)
    return myopts
  end,

  keys = function(_, keys)
    local map_keyword = require("val.map-keyword")
    local keyword = map_keyword.ai
    local bufprefix = "<LocalLeader>" .. keyword
    local prefix = require("val.prefix")

    local more_keys = {
      {
        [1] = "<Leader>" .. keyword,
        [2] = "<cmd>GpChatToggle popup<CR>",
        desc = "gp-chat-toggle",
      },
      {
        [1] = prefix.sidebar .. string.upper(keyword),
        [2] = "<cmd>GpChatToggle vsplit<CR>",
        desc = "gp-chat",
      },
      {
        [1] = bufprefix .. "n",
        [2] = ":<C-u>'<,'>GpChatNew<CR>",
        desc = "gp-chat-with-selected",
        mode = "v",
      },
      {
        [1] = bufprefix .. "e",
        [2] = ":<C-u>'<,'>GpNew<CR>",
        desc = "gp-edit-selected",
        mode = "v",
      },
      {
        [1] = bufprefix .. "E",
        [2] = "<cmd>%GpVnew<CR>",
        desc = "gp-edit-entire-buffer",
      },
      {
        [1] = bufprefix .. "g",
        [2] = ":<C-u>'<,'>GpGrammarCheck<CR>",
        desc = "gp-grammer-check",
        mode = { "v" },
      },
      {
        [1] = bufprefix .. "t",
        [2] = ":<C-u>'<,'>GpEnglishTranslate<CR>",
        desc = "gp-english-translate",
        mode = { "v" },
      },
      {
        [1] = bufprefix .. "p",
        [2] = ":<C-u>'<,'>GpProofread<CR>",
        desc = "gp-proofread",
        mode = { "v" },
      },
      {
        [1] = prefix.close .. keyword,
        [2] = "<cmd>GpStop<CR>",
        desc = "gp-stop",
      },
    }
    vim.list_extend(keys, more_keys)
  end,
  specs = {
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      opts = function(_, opts)
        if opts.icons == nil then
          opts.icons = {}
        end
        if opts.icons.rules == nil then
          opts.icons.rules = {}
        end
        vim.list_extend(opts.icons.rules, {
          { pattern = "gp", icon = require("val.icons").ai, color = "purple" },
        })

        if opts.spec == nil then
          opts.spec = {}
        end
        vim.list_extend(opts.spec, {
          {
            [1] = "<LocalLeader>" .. require("val.map-keyword").ai,
            group = "gp",
            ---@type wk.Icon
            -- icon = icon,
          },
        })
      end,
    },
  },
}
