vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", "j", function() return vim.v.count == 0 and "gj" or "j" end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
map("n", "k", function() return vim.v.count == 0 and "gk" or "k" end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

map("n", "<leader>c", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "n", "nzzzv", { desc = "Next result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })
map("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

map("n", "<A-Down>", "<Cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-Up>", "<Cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("n", "<A-S-Down>", "<Cmd>t.<CR>", { desc = "Duplicate line down" })
map("i", "<A-S-Down>", "<Esc><Cmd>t.<CR>gi", { desc = "Duplicate line down" })
map("n", "<A-S-Up>", "<Cmd>t-1<CR>", { desc = "Duplicate line up" })
map("i", "<A-S-Up>", "<Esc><Cmd>t-1<CR>gi", { desc = "Duplicate line up" })
map("v", "<A-S-Down>", ":t'> <CR>gv", { desc = "Duplicate selection down" })
map("v", "<A-S-Up>", ":t'<-1 <CR>gv", { desc = "Duplicate selection up" })
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

map("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", function()
  local ok, bufremove = pcall(require, "mini.bufremove")
  if ok then bufremove.delete() else vim.cmd("bdelete") end
end, { desc = "Delete buffer" })

map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<leader>sv", "<Cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", "<Cmd>split<CR>", { desc = "Split horizontal" })
map("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase width" })

map("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<Cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
map("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy file path" })
