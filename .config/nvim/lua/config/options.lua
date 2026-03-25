-- ~/.config/nvim/lua/config/options.lua
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use real tabs, displayed as width 4
vim.opt.expandtab = false
vim.opt.shiftwidth = 0
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.list = true -- Enable list mode to show invisible characters
vim.opt.listchars = {
  tab = "» ",    -- Arrow for tabs
  trail = "·",   -- Dot for trailing spaces
  nbsp = "␣",    -- Non-breaking space
  space = "·",   -- Dot for spaces (optional, can be noisy)
}
