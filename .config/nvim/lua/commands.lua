vim.api.nvim_create_user_command("PackAdd", function(opts)
    vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (:PackAdd user/repo1 user/repo2" })

vim.api.nvim_create_user_command("PackDel", function(opts)
    vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel plugin1 plugin2)" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
    if opts.args:match("%S") then
        local plugins = vim.split(opts.args, "%s+", { trimempty = true })
        vim.pack.update(plugins)
    else
        vim.pack.update()
    end
end, { nargs = "*", desc = "Update specific or all plugins" })

-- dotnet
local function dotnet_terminal(command)
    vim.cmd("botright 12split")
    vim.cmd("terminal dotnet " .. command)
    vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("DotnetBuild", function()
    dotnet_terminal("build")
end, {})

vim.api.nvim_create_user_command("DotnetTest", function()
    dotnet_terminal("test")
end, {})

vim.api.nvim_create_user_command("DotnetRun", function()
    dotnet_terminal("run")
end, {})

vim.api.nvim_create_user_command("DotnetWatch", function()
    dotnet_terminal("watch run")
end, {})
