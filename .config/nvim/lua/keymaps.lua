vim.g.mapleader = " "

vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down in visual selection" })
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv", { desc = "Move lines up in visual selection" })

vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up in buffer with cursor centered" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result cursor centered" })

vim.keymap.set("n", "H", "^", { desc = "Jump to start of line" })
vim.keymap.set("n", "L", "$", { desc = "Jump to start of line" })

vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, { desc = "Format local buffer" })
vim.keymap.set("v", "<leader>fm", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format selection" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })

vim.keymap.set("n", "<Esc>", "<cmd>nohl<cr>", { desc = "Clear search highlights" })

vim.keymap.set("n", "<leader>bo", function()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
            require("mini.bufremove").delete(buf, false)
        end
    end
end, { desc = "Close other buffers" })

vim.keymap.set("n", "<leader>bD", function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            require("mini.bufremove").delete(buf, false)
        end
    end
end, { desc = "Close all buffers" })

vim.keymap.set("n", "<leader>pb", function()
    require("mini.extra").pickers.buf_lines({ scope = "all" })
end, { desc = "Pick buffer" })

-- dotnet
vim.keymap.set("n", "<leader>nb", "<cmd>DotnetBuild<cr>", {
    desc = ".NET build",
})

vim.keymap.set("n", "<leader>nt", "<cmd>DotnetTest<cr>", {
    desc = ".NET test",
})

vim.keymap.set("n", "<leader>nr", "<cmd>DotnetRun<cr>", {
    desc = ".NET run",
})

vim.keymap.set("n", "<leader>nw", "<cmd>DotnetWatch<cr>", {
    desc = ".NET watch",
})
