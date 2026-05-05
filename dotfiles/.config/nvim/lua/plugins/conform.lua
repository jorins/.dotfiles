-- Automatic formatter

return {
  'stevearc/conform.nvim',
  opts = {
    format_after_save = {
      async = true,
      lsp_format = "prefer",
    }
  }
}
