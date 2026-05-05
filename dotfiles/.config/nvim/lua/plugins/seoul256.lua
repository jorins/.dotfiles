-- Seoul256 theme

return {
  'junegunn/seoul256.vim',

  config = function ()
    vim.g.seoul256_background = 233
    vim.cmd 'colorscheme seoul256'
  end
}

