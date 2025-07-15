-- lua/core/lsp-keymaps.lua
--
-- 此文件定义了所有 LSP 服务器共享的 on_attach 函数。
-- 它包含了通用的快捷键设置。

local M = {} -- M 是一个惯例，代表 "Module"

function M.on_attach(client, bufnr)
  -- 定义一个本地的 map 函数，简化后续操作
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      noremap = true,
      silent = true,
      buffer = bufnr, -- 确保快捷键只在当前 LSP 激活的 buffer 中生效
      desc = "LSP: " .. desc,
    })
  end

  -- ===================================================================
  -- 定义所有通用的 LSP 快捷键
  -- ===================================================================

  -- 跳转定义
  map("n", "gd", vim.lsp.buf.definition, "跳转到定义")
  -- 查看引用
  map("n", "gr", vim.lsp.buf.references, "查看引用")
  -- 显示悬浮文档
  map("n", "gD", vim.lsp.buf.hover, "显示悬浮文档")
  -- 重命名符号
  map("n", "<leader>rn", vim.lsp.buf.rename, "重命名符号")
  -- 显示代码操作 (如修复、重构等)
  map("n", "<leader>ca", vim.lsp.buf.code_action, "代码操作")
  -- 显示当前行的诊断信息 (错误、警告)
  map("n", "<leader>d", vim.diagnostic.open_float, "显示行诊断信息")
  -- 跳转到上一个/下一个诊断信息
  map("n", "[d", vim.diagnostic.goto_prev, "上一个诊断信息")
  map("n", "]d", vim.diagnostic.goto_next, "下一个诊断信息")

end

return M
