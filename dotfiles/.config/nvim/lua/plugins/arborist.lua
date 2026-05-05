-- Tree Sitter management

return {
  'arborist-ts/arborist.nvim',
  version = '*',
  lazy = false,
  config = function()
    require("arborist").setup({
      prefer_wasm = true,
      update_cadence = "manual",
      install_popular = true,
      ensure_isntalled = {},
    })
  end
}
