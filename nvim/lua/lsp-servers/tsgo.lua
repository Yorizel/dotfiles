return {
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, { "tsgo" })
    end,
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      servers = { "tsgo" },
      ---@diagnostic disable: missing-fields
      config = {
        -- Disable vtsls since we're using tsgo
        vtsls = { autostart = false },
        -- Configure tsgo
        tsgo = {
          cmd = { "tsgo", "--lsp", "--stdio" },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_dir = function(fname)
            local util = require "lspconfig.util"
            return util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")(fname)
          end,
        },
      },
    },
  },
}
