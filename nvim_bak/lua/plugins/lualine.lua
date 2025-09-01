return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				-- 主题：'auto' 或 'tokyonight', 'catppuccin' 等，很多主题都模仿了 airline 的风格
				theme = "auto",
				-- 让状态栏看起来更像 airline 的 "箭头" 风格
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {},
				always_divide_middle = true,
			},
			-- 这里是状态栏内容的布局，我们来模仿 airline
			sections = {
				-- 左侧 A、B、C 部分
				lualine_a = { "mode" }, -- 对应你的 "NORMAL"
				lualine_b = { "branch" }, -- 对应你的 Git 分支
				lualine_c = { "filename" }, -- 对应你的文件名 "~/.vimrc"

				-- 右侧 X、Y、Z 部分
				lualine_x = { "encoding", "fileformat", "filetype" }, -- 对应你的 "[unix]", "vim"
				lualine_y = { "progress" }, -- 对应你的 "0%"
				lualine_z = { "location" }, -- 对应你的 "ln: 1"
			},
			inactive_sections = {
				lualine_c = { "filename" },
				lualine_x = { "location" },
			},
			extensions = {},
		})
	end,
}
