return {
    "saghen/blink.cmp",
    opts = {
        keymap = {
            -- set to 'none' to disable the 'default' preset
            preset = "default",

            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },

            -- 将回车键映射到确认补全
            ["<CR>"] = { "accept", "fallback" },
            -- ctrl+j跳转到下一个snippt槽
            -- ["<C-j>"] = { "snippet_forward", "fallback" },
            -- ctrl+k跳转到上一个snippt槽
            -- ["<C-k>"] = { "snippet_backward", "fallback" },

            -- disable a keymap from the preset
            -- ["<C-e>"] = false, -- or {}
        },
        completion = {
            trigger = {
                -- When true, will prefetch the completion items when entering insert mode
                prefetch_on_insert = true,

                -- When false, will not show the completion window automatically when in a snippet
                show_in_snippet = true,

                -- When true, will show completion window after backspacing
                show_on_backspace = true,

                -- When true, will show completion window after backspacing into a keyword
                show_on_backspace_in_keyword = true,

                -- When true, will show the completion window after accepting a completion and then backspacing into a keyword
                show_on_backspace_after_accept = true,

                -- When true, will show the completion window after entering insert mode and backspacing into keyword
                show_on_backspace_after_insert_enter = true,

                -- When true, will show the completion window after typing any of alphanumerics, `-` or `_`
                show_on_keyword = true,

                -- When true, will show the completion window after typing a trigger character
                show_on_trigger_character = true,

                -- When true, will show the completion window after entering insert mode
                show_on_insert = false,

                -- LSPs can indicate when to show the completion window via trigger characters
                -- however, some LSPs (i.e. tsserver) return characters that would essentially
                -- always show the window. We block these by default.
                show_on_blocked_trigger_characters = { " " },
                -- You can also block per filetype with a function:
                -- show_on_blocked_trigger_characters = function(ctx)
                --   if vim.bo.filetype == 'markdown' then return { ' ', '\n', '\t', '.', '/', '(', '[' } end
                --   return { ' ', '\n', '\t' }
                -- end,

                -- When both this and show_on_trigger_character are true, will show the completion window
                -- when the cursor comes after a trigger character after accepting an item
                show_on_accept_on_trigger_character = true,

                -- When both this and show_on_trigger_character are true, will show the completion window
                -- when the cursor comes after a trigger character when entering insert mode
                show_on_insert_on_trigger_character = true,

                -- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
                -- the completion window when the cursor comes after a trigger character when
                -- entering insert mode/accepting an item
                show_on_x_blocked_trigger_characters = { "'", '"', "(" },
                -- or a function, similar to show_on_blocked_trigger_character
            },
            list = {
                -- Maximum number of items to display
                max_items = 200,

                selection = {
                    -- When `true`, will automatically select the first item in the completion list
                    preselect = false,
                    -- preselect = function(ctx) return vim.bo.filetype ~= 'markdown' end,

                    -- When `true`, inserts the completion item automatically when selecting it
                    -- You may want to bind a key to the `cancel` command (default <C-e>) when using this option,
                    -- which will both undo the selection and hide the completion menu
                    auto_insert = true,
                    -- auto_insert = function(ctx) return vim.bo.filetype ~= 'markdown' end
                },

                cycle = {
                    -- When `true`, calling `select_next` at the _bottom_ of the completion list
                    -- will select the _first_ completion item.
                    from_bottom = true,
                    -- When `true`, calling `select_prev` at the _top_ of the completion list
                    -- will select the _last_ completion item.
                    from_top = true,
                },
            },
        },
    },
}
