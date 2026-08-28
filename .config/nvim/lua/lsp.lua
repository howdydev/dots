require("mason").setup()

vim.diagnostic.config({ virtual_text = true, severity_sort = true, update_in_insert = false })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        }
    }
})

vim.lsp.config("roslyn", {
    settings = {
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
        },
        ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
        }
    }
})

vim.lsp.enable({
    "lua_ls",
    "marksman",
    "gopls",
    "rust_analyzer",
    "ts_ls",
    "taplo",
})

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
