-- lua/plugins/completion.lua

return {
  -- nvim-cmp: 核心补全引擎
  "hrsh7th/nvim-cmp",
  
  -- 这是解决你问题的关键：
  -- event = "InsertEnter" 确保 nvim-cmp 只在你进入插入模式时才加载，提高启动速度。
  -- dependencies 明确了所有补全源都依赖于 nvim-cmp。
  event = "InsertEnter",
  dependencies = {
    -- cmp-nvim-lsp: LSP 补全源
    -- 它依赖于 nvim-cmp，所以作为 nvim-cmp 的依赖项来组织是最佳实践
    "hrsh7th/cmp-nvim-lsp",

    -- luasnip: 代码片段引擎
    "L3MON4D3/LuaSnip",
    -- cmp_luasnip: 将 luasnip 集成到 nvim-cmp
    "saadparwaiz1/cmp_luasnip",

    -- 其他有用的补全源
    "hrsh7th/cmp-buffer",   -- 缓冲区文本补全
    "hrsh7th/cmp-path",     -- 文件路径补全
    "hrsh7th/cmp-cmdline",  -- 命令行补全
    
    -- (可选) friendly-snippets: 提供大量预设的代码片段
    "rafamadriz/friendly-snippets",
  },
  
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- 加载 friendly-snippets 的代码片段
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      -- 指定代码片段引擎
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      
      -- 快捷键映射
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- 回车键确认选择
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      
      -- 指定补全源
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })

    -- 命令行补全设置
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end,
}
