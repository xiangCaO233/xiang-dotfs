-- lua/plugins/lsp-mason.lua

return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig = require("lspconfig")

    -- 从模块中加载通用的 on_attach 和 capabilities
    local lsp_keymaps = require("core.lsp-keymaps")
    local on_attach = lsp_keymaps.on_attach
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.semanticTokens = true

    mason.setup({
      -- 使用 mason.nvim 自己的 ensure_installed 来管理工具的安装
      -- 这里使用 Mason 的包名（Package Name）
      ensure_installed = {
        "clangd",
        "jdtls",
        "sonarlint-language-server",
        "lua-language-server",
        "pyright",
      }
    })

    mason.setup()

    mason_lspconfig.setup({
      ensure_installed = {
        "clangd",
        "jdtls",
        "lua_ls",
        "pyright",
      },
      -- 这是解决问题的关键：为 jdtls 定义一个 handler
      handlers = {
        -- 默认 handler，适用于大多数 LSP
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,

        -- jdtls 的特殊 handler
        ["jdtls"] = function()
          -- 在这里放置所有 jdtls 的特殊配置
          local home = os.getenv('HOME')
          local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
          local workspace_dir = home .. '/.cache/jdtls-workspace/' .. project_name
          vim.fn.mkdir(workspace_dir, "p")

          -- !! 注意这里的变化 !!
          -- 我们不再需要手动查找 jdtls 的路径，lspconfig 会在 mason 的帮助下自动处理
          -- 只需要提供一个相对路径给 javaagent 即可
          local config = {
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = {
              'java',
              '-Declipse.application=org.eclipse.jdt.ls.core.id1.application',
              '-Dosgi.bundles.defaultStartLevel=4',
              '-Declipse.product=org.eclipse.jdt.ls.core.product',
              '-Dlog.protocol=true',
              '-Dlog.level=ALL',
              -- -javaagent 的路径可以直接写相对路径，由 lspconfig 自动解析
              '-javaagent:' .. vim.fn.stdpath('data') .. '/mason/packages/jdtls/lombok.jar',
              '-Xms1g',
              '--add-modules=ALL-SYSTEM',
              '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
              '--add-opens', 'java.base/java.io=ALL-UNNAMED',
              '--add-opens', 'java.base/java.util=ALL-UNNAMED',
              '-jar', vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
              '-configuration', vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_linux', -- 按系统修改
              '-data', workspace_dir,
            },
            root_dir = require('lspconfig.util').root_pattern("pom.xml", "build.gradle", ".git"),
          }
          lspconfig.jdtls.setup(config)
        end,
      }
    })


    -- 更新服务器列表
    local servers = {"clangd", "lua_ls", "pyright"}
    for _, server_name in ipairs(servers) do
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end
    -- 手动配置 sonarlint (因为它不是 lspconfig 内置的)
    -- lspconfig.sonarlint.setup({
    --   on_attach = on_attach,
    --   capabilities = capabilities,
    -- })
  end,
}
