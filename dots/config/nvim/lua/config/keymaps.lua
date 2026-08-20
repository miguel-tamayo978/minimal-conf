-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Abrir archivos recientes con Snacks
vim.keymap.set("n", "<leader>r", function()
  Snacks.picker.recent()
end, { desc = "Abrir archivos recientes" })
