return {
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      icons = {
        VimIcon = "",
        ScrollText = "",
        GitBranch = "",
        GitAdd = "",
        GitChange = "",
        GitDelete = "",
        -- Adding an icon for VectorCode for consistency
        VectorCode = "󰘑",
      },
      status = {
        separators = {
          left = { "", "" },
          right = { "", "" },
          tab = { "", "" },
        },
        colors = function(hl)
          local get_hlgroup = require("astroui").get_hlgroup
          local comment_fg = get_hlgroup("Comment").fg
          hl.git_branch_fg = comment_fg
          hl.git_added = comment_fg
          hl.git_changed = comment_fg
          hl.git_removed = comment_fg
          hl.blank_bg = get_hlgroup("Folded").fg
          hl.file_info_bg = get_hlgroup("Visual").bg
          hl.nav_icon_bg = get_hlgroup("String").fg
          hl.nav_fg = hl.nav_icon_bg
          hl.folder_icon_bg = get_hlgroup("Error").fg
          return hl
        end,
        attributes = {
          mode = { bold = true },
        },
        icon_highlights = {
          file_icon = {
            statusline = false,
          },
        },
      },
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      -- Spinner symbols and CodeCompanion Heirline component (lualine logic)
      local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      local done_symbol = "✓"
      local astroui = require "astroui.status.hl"
      local CodeCompanion = {
        static = {
          n_requests = 0,
          spinner_index = 0,
          spinner_timer = nil,
          start_spinner = function(self)
            if self.spinner_timer then return end
            self.spinner_timer = vim.loop.new_timer()
            self.spinner_timer:start(
              0,
              120,
              vim.schedule_wrap(function()
                self.spinner_index = (self.spinner_index % #spinner_symbols) + 1
                vim.cmd "redrawstatus"
              end)
            )
          end,
          stop_spinner = function(self)
            if self.spinner_timer then
              self.spinner_timer:stop()
              self.spinner_timer:close()
              self.spinner_timer = nil
              self.spinner_index = 0
            end
          end,
        },
        init = function(self)
          if not self._autocmds_set then
            vim.api.nvim_create_autocmd("User", {
              pattern = "CodeCompanionRequestStarted",
              callback = function()
                self.n_requests = self.n_requests + 1
                if self.n_requests == 1 then self:start_spinner() end
                vim.cmd "redrawstatus"
              end,
              group = vim.api.nvim_create_augroup("HeirlineCodeCompanion", { clear = false }),
            })
            vim.api.nvim_create_autocmd("User", {
              pattern = "CodeCompanionRequestFinished",
              callback = function()
                self.n_requests = math.max(0, self.n_requests - 1)
                if self.n_requests == 0 then self:stop_spinner() end
                vim.cmd "redrawstatus"
              end,
              group = vim.api.nvim_create_augroup("HeirlineCodeCompanion", { clear = false }),
            })
            self._autocmds_set = true
          end
        end,
        provider = function(self)
          if not package.loaded["codecompanion"] then return "" end
          local symbol
          if self.n_requests > 0 then
            symbol = spinner_symbols[self.spinner_index > 0 and self.spinner_index or 1]
          else
            symbol = done_symbol
          end
          return (" %d %s "):format(self.n_requests, symbol)
        end,
        hl = function() return astroui.filetype_color() end,
      }

      -- VectorCode spinner component
      local VectorCode = {
        static = {
          processing = false,
          spinner_index = 1,
          spinner_timer = nil,
          start_spinner = function(self)
            if self.spinner_timer then return end
            self.spinner_timer = vim.loop.new_timer()
            self.spinner_timer:start(
              0,
              100,
              vim.schedule_wrap(function()
                self.spinner_index = (self.spinner_index % #spinner_symbols) + 1
                vim.cmd "redrawstatus"
              end)
            )
          end,
          stop_spinner = function(self)
            if self.spinner_timer then
              self.spinner_timer:stop()
              self.spinner_timer:close()
              self.spinner_timer = nil
              self.spinner_index = 1
            end
          end,
        },
        start_processing = function() vim.api.nvim_exec_autocmds("User", { pattern = "VectorCodeRequestStarted" }) end,
        end_processing = function() vim.api.nvim_exec_autocmds("User", { pattern = "VectorCodeRequestFinished" }) end,
        update = {
          "User",
          pattern = "VectorCodeRequest*",
          callback = function(self, args)
            if args.match == "VectorCodeRequestStarted" then
              self.processing = true
              self:start_spinner()
            elseif args.match == "VectorCodeRequestFinished" then
              self.processing = false
              self:stop_spinner()
            end
            vim.cmd "redrawstatus"
          end,
        },
        {
          condition = function(self) return self.processing end,
          provider = function(self)
            return require("astroui").get_icon "VectorCode" .. " " .. spinner_symbols[self.spinner_index]
          end,
          hl = function() return astroui.filetype_color() end,
        },
      }

      -- The main statusline definition
      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },

        status.component.mode {
          mode_text = {
            icon = { kind = "VimIcon", padding = { right = 1, left = 1 } },
          },
          surround = {
            separator = "left",
            color = function() return { main = status.hl.mode_bg(), right = "blank_bg" } end,
          },
        },
        status.component.builder {
          { provider = "" },
          surround = {
            separator = "left",
            color = { main = "blank_bg", right = "file_info_bg" },
          },
        },
        status.component.file_info {
          filename = { fallback = "Empty" },
          filetype = false,
          file_read_only = false,
          padding = { right = 1 },
          surround = { separator = "left", condition = false },
        },
        CodeCompanion,
        status.component.git_branch {
          git_branch = { padding = { left = 1 } },
          surround = { separator = "none" },
        },
        status.component.git_diff {
          padding = { left = 1 },
          surround = { separator = "none" },
        },

        -- VectorCode spinner component
        VectorCode,

        status.component.fill(),
        status.component.lsp {
          lsp_client_names = false,
          surround = { separator = "none", color = "bg" },
        },
        status.component.fill(),
        status.component.diagnostics { surround = { separator = "right" }, padding = { right = 1 } },
        status.component.lsp {
          lsp_progress = false,
          padding = { right = 1 },
          surround = { separator = "right" },
        },
        {
          flexible = 1,
          {
            status.component.builder {
              { provider = require("astroui").get_icon "FolderClosed" },
              padding = { right = 1 },
              hl = { fg = "bg" },
              surround = { separator = "right", color = "folder_icon_bg" },
            },
            status.component.file_info {
              filename = {
                fname = function(nr) return vim.fn.getcwd(nr) end,
                padding = { left = 1, right = 1 },
              },
              filetype = false,
              file_icon = false,
              file_modified = false,
              file_read_only = false,
              surround = {
                separator = "none",
                color = "file_info_bg",
                condition = false,
              },
            },
          },
          {},
        },
        {
          status.component.builder {
            { provider = require("astroui").get_icon "ScrollText" },
            padding = { right = 1 },
            hl = { fg = "bg" },
            surround = {
              separator = "right",
              color = { main = "nav_icon_bg", left = "file_info_bg" },
            },
          },
          status.component.nav {
            percentage = { padding = { right = 1 } },
            ruler = false,
            scrollbar = false,
            surround = { separator = "none", color = "file_info_bg" },
          },
        },
      }
    end,
  },
}
