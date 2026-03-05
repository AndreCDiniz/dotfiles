local keymap = vim.keymap
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- vim.keymap.del("n", "<leader>w|")
-- vim.keymap.del("n", "<leader>|")
keymap.set("n", "<leader>za", "gg0VG", { desc = "Select all", remap = true })
keymap.set("n", "gh", "K", { desc = "Show Hover", remap = true })

-- Busca centralizada: mantém o cursor no centro ao navegar resultados
keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- F2: encontrar e substituir a palavra sob o cursor
keymap.set("n", "<F2>", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Find and replace word under cursor" })

-- Duplicar linha
keymap.set("n", "<M-d>", "yyp", { desc = "Duplicate line" })

-- Abrir URL sob o cursor no browser
keymap.set("n", "<leader>ou", function()
  local url = vim.fn.expand("<cfile>")
  vim.fn.jobstart({ "xdg-open", url }, { detach = true })
  vim.notify("Abrindo: " .. url)
end, { desc = "Open URL under cursor" })

keymap.del("n", "<leader>K")
keymap.del("n", "<leader>-")
keymap.del("n", "<leader>|")
keymap.del("n", "<leader>`")
