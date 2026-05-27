return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Cat ASCII art header
			dashboard.section.header.val = {
				"                                        ",
				"    /\\_____/\\                           ",
				"   /  o   o  \\                          ",
				"  ( ==  ^  == )      N E O V I M        ",
				"   )         (                          ",
				"  (           )                         ",
				" ( (  )   (  ) )                        ",
				"(__(__)___(__)__)                        ",
				"                                        ",
			}

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

			vim.api.nvim_set_hl(0, "AlphaHeader",  { fg = "#cba6f7" }) -- mauve
			vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#89b4fa" }) -- blue
			vim.api.nvim_set_hl(0, "AlphaFooter",  { fg = "#585b70" }) -- surface2

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
