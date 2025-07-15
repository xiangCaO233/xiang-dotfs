-- -----------------------------------------------------------------------------
-- 第一部分：引导和自动安装 lazy.nvim (Bootstrap)
-- -----------------------------------------------------------------------------
-- 核心思想：这段代码的目标是让你的 Neovim 配置具有“自愈”能力
-- 即使你在一个全新的、没有任何插件的系统上使用这份配置，它也会自动下载并安装插件管理器 lazy.nvim
-- 这样，你的配置就可以随处使用了

-- 定义 lazy.nvim 的安装路径。
-- vim.fn.stdpath("data") 会获取 Neovim 的标准数据目录，这在不同操作系统（Windows, macOS, Linux）上是不同的
-- 这样做可以确保路径的跨平台兼容性，而不是硬编码一个路径（如 ~/.local/share/nvim）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 检查 lazy.nvim 是否已经被安装
-- (vim.uv or vim.loop) 是为了兼容新旧不同版本的 Neovim API
-- .fs_stat(lazypath) 会检查指定路径的文件或目录是否存在。如果不存在，则返回 nil
-- `if not ... then` 表示：如果 lazypath 这个目录不存在，那么就执行下面的安装代码
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- 定义 lazy.nvim 的 Git 仓库地址
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"

  -- 执行 git clone 命令来下载 lazy.nvim
  -- "--filter=blob:none": Git 的性能优化参数，部分克隆
  --                       它告诉 Git 只下载提交历史，而不下载每个文件的历史版本内容，可以让克隆速度变得非常快，体积也更小
  -- "--branch=stable":    指定克隆 `stable` 稳定分支，对于日常使用来说稳定版比开发版更可靠
  -- lazyrepo:             要克隆的仓库 URL
  -- lazypath:             要克隆到的本地路径
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

  -- 检查 Git 命令是否执行成功
  if vim.v.shell_error ~= 0 then
    -- 如果克隆失败，则在 Neovim 中显示一个格式化的错误信息。
    vim.api.nvim_echo({
      { "克隆 lazy.nvim 失败:\n", "ErrorMsg" }, -- 第一行，用高亮的 ErrorMsg 样式
      { out, "WarningMsg" },                   -- 第二行，显示 git 命令的输出，用 WarningMsg 样式
      { "\n按任意键退出..." },                  -- 第三行，提示用户
    }, true, {})
    -- 等待用户按下一个键,防止错误信息一闪而过来不及看。
    vim.fn.getchar()
    -- 退出 Neovim
    os.exit(1)
  end
end

-- 将 lazy.nvim 的路径添加到 Neovim 的运行时路径（runtimepath）的 *最前面*。
-- 'rtp' (runtimepath) 就像是操作系统的 PATH 环境变量，Neovim 会在这个路径列表里查找插件和脚本。
-- :prepend() 表示添加到最前面，这至关重要，因为需要先加载 lazy.nvim，然后才能让它去管理其他插件
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------------------
-- 第二部分：核心设置 (在加载 lazy.nvim 之前)
-- -----------------------------------------------------------------------------

-- 设置全局的 <Leader> 键为空格键。
-- Leader 键是自定义快捷键的前缀，可以让你创建一整套属于自己的快捷键，而不用担心和 Vim 内置的快捷键冲突。
-- 使用空格键是现代 Vim/Neovim 配置的一个流行约定，因为它位置顺手且很少被使用。
vim.g.mapleader = " "

-- 设置当前缓冲区的 <LocalLeader> 键为反斜杠。
-- LocalLeader 主要用于那些只针对特定文件类型或缓冲区的快捷键。
vim.g.maplocalleader = "\\"

require("core/core")

-- 在加载 lazy.nvim 之前,请务必设置好 mapleader 和 maplocalleader。
-- 这样可以确保由插件创建的映射（快捷键）能够正确地使用你定义的 Leader 键。

-- -----------------------------------------------------------------------------
-- 第三部分：配置并启动 lazy.nvim
-- -----------------------------------------------------------------------------
-- 调用 lazy.nvim 的 setup 函数，开始进行配置。
-- `require("lazy")` 会加载我们刚刚添加到 rtp 里的 lazy.nvim 模块。
-- `.setup({...})` 函数接收一个配置表（table）作为参数。
require("lazy").setup({
  -- `spec` (specification) 定义了你的插件列表。
  spec = {
    -- 这是一个非常重要的模块化设计！
    -- 这行代码告诉 lazy.nvim 去 'lua/plugins/' 目录下加载所有的 .lua 文件作为插件配置。
    -- 而不是把所有插件配置都堆在这个文件里。
    -- 这样做能让你的配置结构非常清晰、易于管理。
    -- 例如，你可以在 lua/plugins/completion.lua 中放所有关于补全的插件。
    { import = "plugins" },
  },

  -- 在这里配置 lazy.nvim 本身的其它行为,更多细节请查阅 lazy.nvim 的文档。

  -- 在安装插件时，Neovim 界面所使用的主题。
  -- 这只是一个美化选项，让安装过程的界面更好看。
  install = { colorscheme = { "habamax" } },

  -- 配置插件更新检查器。
  checker = {
    enabled = true, -- 启用自动检查。lazy.nvim 会在启动时异步检查是否有插件可以更新。
  },
})
