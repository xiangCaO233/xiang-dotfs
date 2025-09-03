-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 设置快捷键的辅助函数
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "跳转到左侧窗口", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "跳转到下面窗口", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "跳转到上面窗口", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "跳转到右侧窗口", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- 整行移动
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- 缓冲区操作
map("n", "<leader>[", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<leader>]", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
    Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
    Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- -----------------------------------------------------------------------------
-- 禁用方向按键
-- -----------------------------------------------------------------------------

map({ "n", "v", "i" }, "<Up>", "<Nop>")
map({ "n", "v", "i" }, "<Down>", "<Nop>")
map({ "n", "v", "i" }, "<Left>", "<Nop>")
map({ "n", "v", "i" }, "<Right>", "<Nop>")

-- 使用esc清除高亮或停止编辑snippets
map({ "n", "v", "i" }, "<ESC>", function()
    vim.cmd("noh")
    LazyVim.cmp.actions.snippet_stop()
    return "<esc>"
end, { desc = "清除搜索高亮/停止snippits" })

-- 切换模式映射
map("i", "jk", "<ESC>", { desc = "jk退出插入模式" })

-- 快速行移动
map({ "n", "v" }, "K", "6k", { desc = "向上移动5行" })
map({ "n", "v" }, "J", "6j", { desc = "向下移动5行" })

-- 完整的HL行首行尾语义定义
map({ "n", "v" }, "H", "^", { desc = "移动到行首非空白字符" })
map({ "n", "v" }, "L", "$", { desc = "移动到行尾" })
map("n", "dH", "d^", { desc = "剪切到行首" })
map("n", "yH", "y^", { desc = "复制到行首" })
map("n", "dL", "d$", { desc = "剪切到行尾首" })
map("n", "yL", "y$", { desc = "复制到行尾首" })

-- "nnoremap q ge"
map("n", "q", "ge", { desc = "移动到上一个单词的词尾" })

-- 快速保存
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- 可视化模式快速调整缩进
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- 打开lazy页面
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- 新建文件
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- 诊断提示
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quit
map("n", "<leader>wq", "<cmd>wqa<cr>", { desc = "Write and Quit All" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- snippets
-- map("s", "<C-S-a>", function()
--     return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>"
-- end, { expr = true, desc = "Jump Next" })
--
-- map({ "i", "s" }, "<C-S-x>", function()
--     return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>"
-- end, { expr = true, desc = "Jump Previous" })
