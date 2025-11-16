return {
    "neovim/nvim-lspconfig",
    opts = {
        -- diagnostics 配置 (保持不变)
        diagnostics = {
            underline = true,
            update_in_insert = true,
            virtual_text = {
                spacing = 4,
                source = "if_many",
                prefix = "●",
            },
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
                    [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
                    [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
                    [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
                },
            },
        },

        -- inlay_hints, codelens, format (保持不变)
        inlay_hints = { enabled = true, exclude = { "vue" } },
        codelens = { enabled = false },
        format = { formatting_options = nil, timeout_ms = nil },

        -- LSP Server Settings
        servers = {
            -- 为所有服务器 ("*") 设置默认值
            ["*"] = {
                -- 【新改动】将 capabilities 移到这里
                capabilities = {
                    workspace = {
                        fileOperations = {
                            didRename = true,
                            willRename = true,
                        },
                    },
                },
                -- 【之前的改动】快捷键也在这里
                keys = {
                    { "K", false }, -- 禁用 K
                    {
                        "<leader>ch",
                        function()
                            vim.lsp.buf.hover()
                        end,
                        desc = "Hover",
                    }, -- 添加新快捷键
                },
            },

            -- 你自己的 clangd 配置 (保持不变)
            clangd = {
                cmd = { "clangd", "--log=error" },
            },

            -- 你自己的 lua_ls 配置 (保持不变)
            lua_ls = {
                settings = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        codeLens = { enable = true },
                        completion = { callSnippet = "Replace" },
                    },
                },
            },
        },

        -- setup function (保持不变)
        setup = {},
    },
}
