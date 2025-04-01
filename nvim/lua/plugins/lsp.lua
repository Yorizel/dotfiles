return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {

      features = {
        inlay_hints = false,
        eslint_fix_on_save = true,
        signature_help = true, -- enable automatic signature help popup globally on startup
      },
    },
  },
}
