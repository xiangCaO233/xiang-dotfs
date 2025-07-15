-- lua/plugins/explorer.lua 

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false, -- 或者设置为 cmd = "NvimTreeToggle" 进行懒加载
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- 禁用 netrw，防止它和 nvim-tree 冲突
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- 从模块化文件中加载 on_attach 函数
    local on_attach = require("core.nvim-tree-keymappings")

    require("nvim-tree").setup({
      -- 你从 on_attach 文件中加载的快捷键映射
      on_attach = on_attach,

      -- 禁用 netrw 的相关设置，推荐在 setup 中也声明一次
      disable_netrw = true,
      hijack_netrw = true,

      -- 视图和窗口行为配置
      view = {
        -- 初始默认宽度
        width = 44,
        -- 保持窗口比例，实现持久化宽度
        preserve_window_proportions = true,
        -- 其他视图设置
        side = "left",
        number = true,
        relativenumber = false, -- 你可以根据喜好设置
      },
      -- 文件操作行为
      actions = {
        open_file = {
          -- 打开文件时，文件树窗口不关闭
          quit_on_open = false,
        },
      },
      renderer = {
        -- 在图标旁边添加一个分组标记，让文件夹和文件对齐
        group_empty = true,

        -- 这是解决你问题的核心配置
        indent_markers = {
          -- 启用缩进标记 (树状连接线)
          enable = true,
        },
      },
    })
  end,
}
