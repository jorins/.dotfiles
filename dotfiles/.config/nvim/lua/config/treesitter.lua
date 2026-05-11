vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local filetype = vim.bo.filetype
    if filetype and filetype ~= "" then
      pcall(vim.treesitter.start)
    end
  end,
})
