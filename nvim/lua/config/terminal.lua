local augroup = vim.api.nvim_create_augroup("TerminalConfig", { clear = true })

vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

local function make_float(st, cmd)
  if st.is_open and st.win and vim.api.nvim_win_is_valid(st.win) then
    vim.api.nvim_win_close(st.win, false)
    st.is_open = false
    return
  end

  if not st.buf or not vim.api.nvim_buf_is_valid(st.buf) then
    st.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[st.buf].bufhidden = "hide"
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  st.win = vim.api.nvim_open_win(st.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  vim.wo[st.win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

  local lines = vim.api.nvim_buf_get_lines(st.buf, 0, -1, false)
  local is_empty = #lines == 0 or (#lines == 1 and lines[1] == "")
  if is_empty then vim.fn.termopen(cmd) end

  st.is_open = true
  vim.cmd("startinsert")

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = st.buf,
    once = true,
    callback = function()
      if st.is_open and st.win and vim.api.nvim_win_is_valid(st.win) then
        vim.api.nvim_win_close(st.win, false)
        st.is_open = false
      end
    end,
  })
end

local shell_state = { buf = nil, win = nil, is_open = false }
local lazygit_state = { buf = nil, win = nil, is_open = false }

vim.keymap.set("n", "<leader>t", function()
  make_float(shell_state, os.getenv("SHELL"))
end, { desc = "Toggle floating terminal" })

vim.keymap.set("n", "<leader>gg", function()
  make_float(lazygit_state, "lazygit")
end, { desc = "Toggle lazygit" })

vim.keymap.set("t", "<Esc>", function()
  for _, st in ipairs({ shell_state, lazygit_state }) do
    if st.is_open and st.win and vim.api.nvim_win_is_valid(st.win) then
      vim.api.nvim_win_close(st.win, false)
      st.is_open = false
    end
  end
end, { noremap = true, silent = true, desc = "Close floating terminal" })
