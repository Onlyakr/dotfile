local augroup = vim.api.nvim_create_augroup("TerminalConfig", { clear = true })

-- plain :terminal buffers: drop them once the job exits cleanly.
-- args.buf, not 0: the job can finish while another buffer is current.
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  callback = function(args)
    if vim.v.event.status == 0 and vim.api.nvim_buf_is_valid(args.buf) then
      vim.api.nvim_buf_delete(args.buf, { force = true })
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

local function close_float(st)
  if st.win and vim.api.nvim_win_is_valid(st.win) then
    vim.api.nvim_win_close(st.win, false)
  end
  st.win = nil
  st.is_open = false
end

local function make_float(st, cmd)
  if st.is_open and st.win and vim.api.nvim_win_is_valid(st.win) then
    close_float(st)
    return
  end

  -- a buffer whose job already exited (any status) is dead: start fresh
  local job_alive = st.job and vim.fn.jobwait({ st.job }, 0)[1] == -1
  if not st.buf or not vim.api.nvim_buf_is_valid(st.buf) or not job_alive then
    if st.buf and vim.api.nvim_buf_is_valid(st.buf) then
      vim.api.nvim_buf_delete(st.buf, { force = true })
    end
    st.buf = vim.api.nvim_create_buf(false, true)
    st.job = nil
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

  if not st.job then
    st.job = vim.fn.jobstart(cmd, {
      term = true,
      on_exit = function()
        -- float terminals go away with their job regardless of exit status
        close_float(st)
        if st.buf and vim.api.nvim_buf_is_valid(st.buf) then
          vim.api.nvim_buf_delete(st.buf, { force = true })
        end
        st.buf = nil
        st.job = nil
      end,
    })
    -- buffer-local, double tap: a single <Esc> still reaches the program
    -- (lazygit uses it for back/cancel, zsh vi-mode for normal mode).
    vim.keymap.set("t", "<Esc><Esc>", function()
      close_float(st)
    end, { buffer = st.buf, silent = true, desc = "Hide floating terminal" })
  end

  st.is_open = true
  vim.cmd("startinsert")

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = st.buf,
    once = true,
    callback = function()
      close_float(st)
    end,
  })
end

local shell_state = { buf = nil, win = nil, job = nil, is_open = false }
local lazygit_state = { buf = nil, win = nil, job = nil, is_open = false }

vim.keymap.set("n", "<leader>t", function()
  make_float(shell_state, os.getenv("SHELL") or vim.o.shell)
end, { desc = "Toggle floating terminal" })

vim.keymap.set("n", "<leader>gg", function()
  make_float(lazygit_state, "lazygit")
end, { desc = "Toggle lazygit" })
