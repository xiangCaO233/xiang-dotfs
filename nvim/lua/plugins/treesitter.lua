-- lua/plugins/treesitter.lua

return {
  "nvim-treesitter/nvim-treesitter",
  -- 这是一个关键的构建命令
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- 确保你想要支持的语言在这里列出
      ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "python", "rust", "html", "css" },

      -- 启动时同步安装 (如果你有很多解析器，可以设为 false)
      sync_install = false,

      -- 启用高亮模块
      highlight = {
        enable = true,
      },

      -- 其他模块
      indent = { enable = true },
	  additional_vim_regex_highlighting = {'c', 'cpp'},
    })
  end,
}
