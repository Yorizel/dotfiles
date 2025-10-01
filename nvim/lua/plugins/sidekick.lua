return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = {
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
    -- Remove the keys.accept = nil since we're handling Tab directly
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<leader>a",
      "",
      desc = "+ai",
      mode = { "n", "v" },
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle { focus = true } end,
      desc = "Sidekick Toggle CLI",
      mode = { "n", "v" },
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle { name = "claude", focus = true } end,
      desc = "Sidekick Claude Toggle",
      mode = { "n" },
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").select_prompt() end,
      desc = "Sidekick Ask Prompt",
      mode = { "n", "v" },
    },
    {
      "<c-.>",
      function() require("sidekick.cli").focus() end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Switch Focus",
    },
    -- Clear suggestions mapping
    {
      "<C-]>",
      function()
        local nes = require "sidekick.nes"
        if nes.have() then nes.clear() end

        local copilot_suggestion = require "copilot.suggestion"
        if copilot_suggestion.is_visible() then copilot_suggestion.dismiss() end
      end,
      mode = { "i", "n" },
      desc = "Clear AI suggestions",
    },
  },
}
