return {
  {
    "AstroNvim/astrocore",
    opts = {
      options = {
        g = {
          ai_inline = true,
          ai_accept = nil, -- set in cursortab.lua to connect to the completion engine
        },
      },
    },
  },
  {
    "Saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      if not opts.keymap then opts.keymap = {} end
      opts.keymap["<Tab>"] = {
        "snippet_forward",
        function()
          if vim.g.ai_accept then return vim.g.ai_accept() end
        end,
        "fallback",
      }
      opts.keymap["<S-Tab>"] = { "snippet_backward", "fallback" }
    end,
  },
  {
    "leonardcser/cursortab.nvim",
    event = "BufReadPost",
    build = "cd server && go build",
    opts = {
      provider = {
        type = "sweep",
        url = "http://localhost:8000",
      },
      keymaps = {
        accept = false, -- handled by ai_accept
      },
      blink = {
        enabled = true,
        ghost_text = false,
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          options = {
            g = {
              -- set the ai_accept function (handles CursorTab suggestions)
              ai_accept = function()
                local ok, cursortab = pcall(require, "cursortab")
                if ok and cursortab.accept then
                  return cursortab.accept()
                end
                return false
              end,
            },
          },

          mappings = {
            -- Normal mode mapping for CursorTab accept
            n = {
              ["<Tab>"] = {
                function()
                  local ok, cursortab = pcall(require, "cursortab")
                  if ok and cursortab.accept then
                    if cursortab.accept() then return end
                  end
                  -- fallback to default Tab behavior
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
                end,
                desc = "Accept AI suggestion (CursorTab)",
              },
            },
          },
        },
      },
    },
  },
}
