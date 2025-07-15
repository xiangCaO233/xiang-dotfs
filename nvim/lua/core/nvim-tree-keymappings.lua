-- 这个函数将作为 on_attach 的回调
local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  -- 定义快捷键的辅助函数，确保它们是缓冲区本地的 (buffer-local)
  local function map(mode, lhs, rhs, opts)
    -- 快捷键只在 nvim-tree 的 buffer 中生效
    local options = { noremap = true, silent = true, buffer = bufnr }
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
  end

  -- 获取跨平台的系统打开命令
  local function get_system_open_cmd()
    if vim.fn.has("mac") == 1 then
      return "open"
    elseif vim.fn.has("unix") == 1 then
      return "xdg-open"
    elseif vim.fn.has("win32") == 1 then
      return "explorer"
    else
      return nil
    end
  end

  -- -------------------------------------------------------------------
  -- 所有 nvim-tree 快捷键
  -- -------------------------------------------------------------------

    -- --- L 键的行为 ---
    -- --- 小写 l 键 ---
  -- 目标：在文件夹上展开，在文件上打开
  map("n", "l", api.node.open.edit, { desc = "展开目录 / 打开文件" })
  map("n", "o", api.node.open.edit, { desc = "展开目录 / 打开文件" })
  -- `api.node.open.edit` 函数内部已经包含了智能判断：
  -- 如果是文件夹，就展开/折叠 (toggle)。
  -- 如果是文件，就打开。
    -- --- 大写 L 键 ---
  -- 文件上新标签页打开；文件夹上用系统管理器打开
  local function custom_L_action()
    local node = api.tree.get_node_under_cursor()
    if not node then return end

    if node.type == "directory" then
      local open_cmd = get_system_open_cmd()
      if open_cmd then
        vim.fn.jobstart({ open_cmd, node.absolute_path }, { detach = true })
      end
    else
      api.node.open.tab()
    end
  end
  map("n", "L", custom_L_action, { desc = "新标签页打开 / 系统打开" })

  -- --- Enter 键的行为 ---
  -- 在文件夹上设为根目录，在文件上打开
  local function custom_enter_action()
    local node = api.tree.get_node_under_cursor()
    if not node then return end

    if node.type == "directory" then
      -- 如果是文件夹，则将其设置为新的根目录
      api.tree.change_root(node.absolute_path)
    else
      -- 如果是文件，则打开它
      api.node.open.edit()
    end
  end
  map("n", "<CR>", custom_enter_action, { desc = "设为根目录 / 打开文件" })

  -- --- H 键的行为 ---
    -- --- 小写 h 键 ---
  -- 在文件夹上收起，在文件上跳转到父目录
  local function custom_h_action()
    local node = api.tree.get_node_under_cursor()
    if not node then return end

    if node.type == "directory" then
      -- 如果是已展开的文件夹，则收起它
      if node.open then
        api.node.open.edit() -- open.edit 在已打开的目录上会折叠它
      else
        -- 如果是已收起的文件夹，则跳转到父目录
        api.node.navigate.parent_close()
      end
    else
      -- 如果是文件，则跳转到其所在的父目录
      api.node.navigate.parent()
    end
  end
  map("n", "h", custom_h_action, { desc = "收起目录 / 跳转至父目录" })
    -- --- 大写 H 键 ---
  -- 无论在文件还是文件夹上，都收起其父目录
  local function custom_H_action()
    local node = api.tree.get_node_under_cursor()
    if not node then return end

    local parent_node = api.tree.get_node(node.parent)
    if parent_node and parent_node.open then
      api.node.open.edit({ node = parent_node })
    else
      api.node.navigate.parent_close()
    end
  end
  map("n", "H", custom_H_action, { desc = "收起父目录" })

    -- --- J 和 K - 快速导航 ---
  map("n", "J", "5j", { desc = "向下移动5行" })
  map("n", "K", "5k", { desc = "向上移动5行" })

  -- --- 文件操作 ---
  -- --- R 键 - 重命名 ---
  map("n", "r", api.fs.rename, { desc = "重命名" })


  -- --- DD, YY, P - 剪切/复制/粘贴 ---
  map("n", "dd", api.fs.cut, { desc = "剪切" })
  map("n", "D", api.fs.remove , { desc = "删除" })
  map("n", "yy", api.fs.copy.node, { desc = "复制" })
  map("n", "p", api.fs.paste, { desc = "粘贴" })

  -- 新建文件 --
  map("n", "a", api.fs.create, { desc = "新建" })
  -- 显示隐藏文件 --
  map("n", ".", api.tree.toggle_hidden_filter, { desc = "切换显示隐藏文件" })
end

return on_attach
