# Neovim Config

Requires Neovim 0.12+.

## System dependencies

Arch Linux:

```bash
sudo pacman -S --needed \
    neovim \
    git \
    ripgrep \
    fd \
    tree-sitter-cli \
    gcc \
    nodejs \
    rustup \
    dotnet-sdk \
    go
```

## Mason

Inside Neovim:
```
:MasonInstall lua_ls marksman gopls ts_ls taplo
:MasonInstall roslyn-language-server netcoredbg
```

## C# / .NET

C# language support uses:
- roslyn.nvim
- roslyn-language-server
- nvim-dap
- netcoredbg

#### Useful mappings:

```
<leader>rn      Rename
<leader>ca      Code action
gd              Go to definition
gr              Go to reference
gi              Go to implementation
K               Hover
<leader>fm      Format

<leader>nb      dotnet build
<leader>nt      dotnet test
<leader>nr      dotnet run
<leader>nw      dotnet watch run

<leader>db      Breakpoint
<leader>dc      Debug / Continue
<leader>do      Step over
<leader>di      Step into
<leader>dO      step out
<leader>dt      Debugger UI
```
