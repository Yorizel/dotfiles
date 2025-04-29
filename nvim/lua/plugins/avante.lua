local prefix = "<Leader>A"
return {
  {
    "yetone/avante.nvim",
    build = vim.fn.has "win32" == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "User AstroFile", -- load on file open because Avante manages its own bindings
    cmd = {
      "AvanteAsk",
      "AvanteBuild",
      "AvanteEdit",
      "AvanteRefresh",
      "AvanteSwitchProvider",
      "AvanteShowRepoMap",
      "AvanteModels",
      "AvanteChat",
      "AvanteToggle",
      "AvanteClear",
      "AvanteFocus",
      "AvanteStop",
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      { "AstroNvim/astrocore", opts = function(_, opts) opts.mappings.n[prefix] = { desc = " Avante" } end },
    },
    opts = {
      mappings = {
        ask = prefix .. "<CR>",
        edit = prefix .. "e",
        refresh = prefix .. "r",
        focus = prefix .. "f",
        select_model = prefix .. "?",
        stop = prefix .. "S",
        select_history = prefix .. "H",
        toggle = {
          default = prefix .. "t",
          debug = prefix .. "d",
          hint = prefix .. "h",
          suggestion = prefix .. "s",
          repomap = prefix .. "R",
        },
        diff = {
          next = "]c",
          prev = "[c",
        },
        files = {
          add_all_buffers = prefix .. "B",
          add_current = prefix .. ".",
        },
      },
    },
    specs = { -- configure optional plugins
      { "AstroNvim/astroui", opts = { icons = { Avante = "" } } },
      {
        "Kaiser-Yang/blink-cmp-avante",
        lazy = true,
        specs = {
          {
            "Saghen/blink.cmp",
            optional = true,
            opts = {
              sources = {
                default = { "avante" },
                providers = {
                  avante = { module = "blink-cmp-avante", name = "Avante" },
                },
              },
            },
          },
        },
      },
      {
        "nvim-neo-tree/neo-tree.nvim",
        optional = true,
        opts = {
          filesystem = {
            commands = {
              avante_add_files = function(state)
                local node = state.tree:get_node()
                local filepath = node:get_id()
                local relative_path = require("avante.utils").relative_path(filepath)

                local sidebar = require("avante").get()

                local open = sidebar:is_open()
                -- ensure avante sidebar is open
                if not open then
                  require("avante.api").ask()
                  sidebar = require("avante").get()
                end

                sidebar.file_selector:add_selected_file(relative_path)

                -- remove neo tree buffer
                if not open then sidebar.file_selector:remove_selected_file "neo-tree filesystem [1]" end
              end,
            },
          },
          window = {
            mappings = {
              ["oa"] = "avante_add_files",
            },
          },
        },
      },

      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      { -- if copilot.lua is available, default to copilot provider
        "zbirenbaum/copilot.lua",
        optional = true,
        specs = {
          {
            "yetone/avante.nvim",
            opts = {
              vendors = {
                ["copilot-2.5-pro"] = {
                  __inherited_from = "copilot",
                  model = "gemini-2.5-pro",
                },
              },
              provider = "copilot",
            },
          },
        },
      },
      {
        "folke/snacks.nvim",
        optional = true,
        specs = {
          {
            "yetone/avante.nvim",
            opts = {
              selector = {
                provider = "snacks",
              },
            },
          },
        },
      },
      {
        -- make sure `Avante` is added as a filetype
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        opts = function(_, opts)
          if not opts.file_types then opts.file_types = { "markdown" } end
          opts.file_types = require("astrocore").list_insert_unique(opts.file_types, { "Avante" })
        end,
      },
    },
  },
}
