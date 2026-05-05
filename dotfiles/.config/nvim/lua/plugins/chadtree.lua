-- File explorer

return {
  'ms-jpq/chadtree',
  branch = 'chad',
  build = 'python3 -m chadtree deps',
  lazy = false,
  keys = {
    {
      "<M-e>",
      ":CHADopen<CR>",
      silent = true,
      desc = "Toggle file explorer (CHADtree)"
    }
  },

  config = function()
    vim.api.nvim_set_var("chadtree_settings", {
      keymap = {
        primary = { '<Enter>', 'l' },
        collapse = { '<S-Tab>', '`', 'h' }
      }
    })
  end
}
