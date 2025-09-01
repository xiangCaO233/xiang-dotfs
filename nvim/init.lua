-- bootstrap lazy.nvim, LazyVim and your plugins
package.loaded["lazyvim.config.options"] = true

-- 设置全局的 <Leader> 键为空格键。
-- Leader 键是自定义快捷键的前缀，可以让你创建一整套属于自己的快捷键，而不用担心和 Vim 内置的快捷键冲突。
-- 使用空格键是现代 Vim/Neovim 配置的一个流行约定，因为它位置顺手且很少被使用。
vim.g.mapleader = " "

-- 设置当前缓冲区的 <LocalLeader> 键为反斜杠。
-- LocalLeader 主要用于那些只针对特定文件类型或缓冲区的快捷键。
vim.g.maplocalleader = "\\"

require("config.lazy")
