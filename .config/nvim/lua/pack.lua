vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/folke/tokyonight.nvim",
    "https://github.com/folke/todo-comments.nvim",
    "https://github.com/folke/flash.nvim",
    "https://github.com/tpope/vim-sleuth",
    "https://github.com/saecki/crates.nvim",
    "https://github.com/L3MON4D3/LuaSnip",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/seblj/roslyn.nvim",
    "https://github.com/MagicDuck/grug-far.nvim",
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio",
})

local function setup(mod, opts)
    require(mod).setup(opts or {})
end

setup("mini.pairs")
setup("mini.ai")
setup("mini.surround", {
    mappings = {
        add = "<leader>sa",
        delete = "<leader>sd",
        replace = "<leader>sr",
        find = "<leader>sf",
        find_left = "<leader>sF",
        highlight = "<leader>sh",
        update_n_lines = "<leader>sn",
    }
})
setup("mini.statusline")
setup("mini.tabline")
setup("mini.indentscope")
setup("mini.cmdline", { autocorrect = { enable = false } })
setup("mini.notify", {
    content = {
        format = function(n) return n.msg end,
    },
})
setup("mini.comment", {
    mappings = {
        comment = "<leader>cm",
        comment_line = "<leader>cm",
        comment_visual = "<leader>cm",
    },
})
setup("mini.completion", {
    lsp_completion = { auto_setup = true },
    mappings = {
        force_twostep = "<C-Space>",
        force_fallback = "<A-Space>",
    },
})

require("mini.splitjoin").setup()

local mini_diff = require("mini.diff")
mini_diff.setup({ source = mini_diff.gen_source.git({ index = false }) })

local mini_files = require("mini.files")
mini_files.setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})
vim.keymap.set("n", "-", function() mini_files.open() end, { desc = "File explorer" })
vim.keymap.set("n", "<leader>-", function()
    mini_files.open(vim.api.nvim_buf_get_name(0), false)
    mini_files.reveal_cwd()
end, { desc = "Reveal current file" })

local mini_pick = require("mini.pick")
local mini_extra = require("mini.extra")
mini_pick.setup()
vim.keymap.set("n", "<leader><leader>", function() mini_pick.builtin.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>ps", function() mini_pick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
    { desc = "Grep word" })
vim.keymap.set("n", "<leader>/", function() mini_extra.pickers.buf_lines({ scope = "current" }) end,
    { desc = "Buffer lines" })
vim.keymap.set("n", "<leader>vh", function() mini_pick.builtin.help() end, { desc = "Help" })
vim.keymap.set("n", "<leader>xx", function() mini_extra.pickers.diagnostic() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>pk", function() mini_extra.pickers.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>pS", function()
    mini_extra.pickers.lsp({ scope = "document_symbol " })
end, { desc = "Document symbols " })
vim.keymap.set("n", "<leader>pW", function()
    mini_extra.pickers.lsp({ scope = "workspace_symbols" })
end, { desc = "Workspace symbols " })

local mini_buf_remove = require("mini.bufremove")
mini_buf_remove.setup()
vim.keymap.set("n", "<leader>bd", mini_buf_remove.delete, { desc = "Delete buffer" })

local mini_clue = require("mini.clue")
mini_clue.setup({
    window = { delay = 300 },
    triggers = {
        { mode = "n", keys = "<leader>" },
        { mode = "x", keys = "<leader>" },
        { mode = "n", keys = "g" },
        { mode = "n", keys = "s" },
    },
    clues = {
        mini_clue.gen_clues.builtin_completion(),
        mini_clue.gen_clues.g(),
        mini_clue.gen_clues.marks(),
        mini_clue.gen_clues.registers(),
        mini_clue.gen_clues.windows(),
    },
})

local mini_starter = require("mini.starter")
mini_starter.setup({
    evaluate_single = true,
    items = {
        mini_starter.sections.recent_files(5, true),
        mini_starter.sections.builtin_actions(),
    },
    content_hooks = {
        mini_starter.gen_hook.adding_bullet(),
        mini_starter.gen_hook.aligning("center", "center"),
    },
    header = [[
    __  __                  __
   / / / /___ _      ______/ /_  __
  / /_/ / __ \ | /| / / __  / / / /
 / __  / /_/ / |/ |/ / /_/ / /_/ /
/_/ /_/\____/|__/|__/\__,_/\__, /
                          /____/
]],
})

require("todo-comments").setup()

local flash = require("flash")
flash.setup()

vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash jump" })
vim.keymap.set({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash treesitter" })

require("crates").setup()

local luasnip = require("luasnip")
luasnip.setup()

require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set("i", "<Tab>", function()
    if luasnip.expand_or_jumpable() then
        return luasnip.expand_or_jump()
    end
    return "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", function()
    if luasnip.jumpable(-1) then
        return luasnip.jump(-1)
    end
    return "<S-Tab>"
end, { expr = true })

require("roslyn").setup()

require("grug-far").setup()
vim.keymap.set("n", "<leader>sr", "<cmd>GrugFar<cr>", { desc = "Search & replace" })
vim.keymap.set("v", "<leader>sr", function()
    require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search & replace word" })

local dap = require("dap")
local dapui = require("dapui")

local netcoredbg = vim.fn.exepath("netcoredbg")

if netcoredbg == "" then
    vim.notify("netcoredbg not found. Install it with :MasonInstall netcoredbg", vim.log.levels.WARN)
else
    dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg,
        args = { "--interpreter=vscode" },
    }
end

local function find_dotnet_dll()
    local cwd = vim.fn.getcwd()

    local projects = vim.fn.glob(
        cwd .. "/**/*.csproj",
        false,
        true
    )

    local dlls = {}

    for _, project in ipairs(projects) do
        local project_dir = vim.fn.fnamemodify(project, ":h")
        local project_name = vim.fn.fnamemodify(project, ":t:r")

        local outputs = vim.fn.glob(
            project_dir
                .. "/bin/Debug/*/"
                .. project_name
                .. ".dll",
            false,
            true
        )

        for _, dll in ipairs(outputs) do
            table.insert(dlls, dll)
        end
    end

    if #dlls == 0 then
        vim.notify(
            "No built .NET DLL found. Run dotnet build first.",
            vim.log.levels.ERROR
        )

        return nil
    end

    if #dlls == 1 then
        return dlls[1]
    end

    local choices = {
        "Select .NET project:",
    }

    for index, dll in ipairs(dlls) do
        table.insert(
            choices,
            string.format(
                "%d. %s",
                index,
                vim.fn.fnamemodify(dll, ":~:.")
            )
        )
    end

    local choice = vim.fn.inputlist(choices)

    if choice < 1 or choice > #dlls then
        return nil
    end

    return dlls[choice]
end

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "Launch .NET",
        request = "launch",

        program = function()
            return find_dotnet_dll()
        end,
    },
}

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue / start" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Toggle DAP UI" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
