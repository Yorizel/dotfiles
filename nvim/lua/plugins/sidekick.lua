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
  specs = {
    { "nvzone/showkeys", cmd = "ShowkeysToggle" },
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        local maps = assert(opts.mappings)
        local prefix = "<Leader>a"

        -- Normal mode mappings
        maps.n[prefix] = { desc = "+ Sidekick" }
        maps.n[prefix .. "a"] = {
          function() require("sidekick.cli").toggle { focus = true } end,
          desc = "Sidekick Toggle CLI",
        }
        maps.n[prefix .. "c"] = {
          function() require("sidekick.cli").toggle { name = "claude", focus = true } end,
          desc = "Sidekick Claude Toggle",
        }
        maps.n[prefix .. "p"] = {
          function() require("sidekick.cli").prompt() end,
          desc = "Sidekick Ask Prompt",
        }

        -- Visual mode mappings
        maps.v[prefix] = { desc = "+ai" }
        maps.v[prefix .. "a"] = {
          function() require("sidekick.cli").toggle { focus = true } end,
          desc = "Sidekick Toggle CLI",
        }
        maps.v[prefix .. "p"] = {
          function() require("sidekick.cli").prompt() end,
          desc = "Sidekick Ask Prompt",
        }

        maps.n["<tab>"] = {
          function()
            -- if there is a next edit, jump to it, otherwise apply it if any
            if not require("sidekick").nes_jump_or_apply() then
              return "<Tab>" -- fallback to normal tab
            end
          end,
          expr = true,
          desc = "Goto/Apply Next Edit Suggestion",
        }
      end,
    },
  },
}
