return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Cat dot-art header (braille), read from a file so the art can be
			-- regenerated independently — see ~/.config/fastfetch/gen-logo.sh.
			local cat = vim.fn.filereadable(vim.fn.expand("~/.config/nvim/cat.txt")) == 1
					and vim.fn.readfile(vim.fn.expand("~/.config/nvim/cat.txt"))
				or { "  /\\_/\\  ", " ( o.o ) ", "  > ^ <  " }
			vim.list_extend(cat, { "", "Hewwo world :3 meow" })
			dashboard.section.header.val = cat

			-- Buttons
			dashboard.section.buttons.val = {
				dashboard.button("n", "  New File",      "<Cmd>ene <BAR> startinsert<CR>"),
				dashboard.button("f", "  Find File",     "<Cmd>FzfLua files<CR>"),
				dashboard.button("r", "  Recent Files",  "<Cmd>FzfLua oldfiles<CR>"),
				dashboard.button("g", "  Live Grep",     "<Cmd>FzfLua live_grep<CR>"),
				dashboard.button("q", "  Quit",          "<Cmd>qa<CR>"),
			}

			-- Footer
			local version = vim.version()
			dashboard.section.footer.val = "nvim v" .. version.major .. "." .. version.minor .. "." .. version.patch

			-- Styling
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.section.footer.opts.hl = "AlphaFooter"

			-- follow the active theme: greyscale under mono, catppuccin otherwise
			if vim.g.colors_name == "mono" then
				vim.api.nvim_set_hl(0, "AlphaHeader",  { fg = "#e0e0e0" })
				vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#a0a0a0" })
				vim.api.nvim_set_hl(0, "AlphaFooter",  { fg = "#606060" })
			else
				vim.api.nvim_set_hl(0, "AlphaHeader",  { fg = "#cba6f7" }) -- mauve
				vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#89b4fa" }) -- blue
				vim.api.nvim_set_hl(0, "AlphaFooter",  { fg = "#585b70" }) -- surface2
			end

			alpha.setup(dashboard.config)

			-- Don't show statusline on dashboard
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					vim.opt.laststatus = 0
				end,
			})
			vim.api.nvim_create_autocmd("BufUnload", {
				buffer = 0,
				callback = function()
					vim.opt.laststatus = 3
				end,
			})
		end,
	},
}
