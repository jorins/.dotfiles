-- Tree Sitter management

return {
  'arborist-ts/arborist.nvim',
  version = '*',
  lazy = false,
  opts = {
    prefer_wasm = true,
    update_cadence = "manual",
    install_popular = true,
    ensure_isntalled = {},
  }
}
