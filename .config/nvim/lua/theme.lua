require("tokyonight").setup({
    style = "night",
    transparent = false,

    styles = {
        comments = { italic = false },
        keywords = { italic = false },
        sidebars = "dark",
        floats = "dark",
    },

    on_colors = function(colors)
        colors.bg = "#080A0F"
        colors.bg_dark = "#080A0F"
        colors.bg_float = "#0D1018"
        colors.bg_popup = "#0D1018"
        colors.bg_sidebar = "#0D1018"
        colors.bg_statusline = "#0D1018"

        colors.bg_highlight = "#121722"
        colors.bg_visual = "#202638"

        colors.fg = "#A9B1D6"
        colors.fg_dark = "#565F89"
        colors.fg_gutter = "#3B4261"

        colors.blue = "#7AA2F7"
        colors.cyan = "#7DCFFF"
        colors.purple = "#BB9AF7"

        colors.green = "#9ECE6A"
        colors.yellow = "#E0AF68"
        colors.red = "#F7768E"

        colors.comment = "#565F89"
        colors.border = "#202638"
    end,

    on_highlights = function(hl, colors)
        hl.Normal = {
            fg = colors.fg,
            bg = "#080A0F",
        }

        hl.NormalNC = {
            fg = colors.fg,
            bg = "#080A0F",
        }

        hl.NormalFloat = {
            fg = colors.fg,
            bg = "#0D1018",
        }

        hl.FloatBorder = {
            fg = "#202638",
            bg = "#0D1018",
        }

        hl.FloatTitle = {
            fg = "#7AA2F7",
            bg = "#0D1018",
            bold = true,
        }

        -- Splits
        hl.WinSeparator = {
            fg = "#202638",
            bg = "#080A0F",
        }

        -- Line numbers
        hl.LineNr = {
            fg = "#3B4261",
            bg = "#080A0F",
        }

        hl.CursorLineNr = {
            fg = "#7AA2F7",
            bg = "#080A0F",
            bold = true,
        }

        hl.CursorLine = {
            bg = "#0D1018",
        }

        -- Selection
        hl.Visual = {
            bg = "#202638",
        }

        hl.Search = {
            fg = "#080A0F",
            bg = "#E0AF68",
        }

        hl.IncSearch = {
            fg = "#080A0F",
            bg = "#7DCFFF",
        }

        -- Tabs / buffers
        hl.TabLine = {
            fg = "#565F89",
            bg = "#080A0F",
        }

        hl.TabLineSel = {
            fg = "#7AA2F7",
            bg = "#080A0F",
            bold = true,
        }

        hl.TabLineFill = {
            bg = "#080A0F",
        }

        -- Popups
        hl.Pmenu = {
            fg = "#A9B1D6",
            bg = "#0D1018",
        }

        hl.PmenuSel = {
            fg = "#080A0F",
            bg = "#7AA2F7",
            bold = true,
        }

        hl.PmenuSbar = {
            bg = "#121722",
        }

        hl.PmenuThumb = {
            bg = "#565F89",
        }

        -- Diagnostics
        hl.DiagnosticError = {
            fg = "#F7768E",
        }

        hl.DiagnosticWarn = {
            fg = "#E0AF68",
        }

        hl.DiagnosticInfo = {
            fg = "#7DCFFF",
        }

        hl.DiagnosticHint = {
            fg = "#7AA2F7",
        }

        -- Mini.nvim
        hl.MiniStatuslineModeNormal = {
            fg = "#080A0F",
            bg = "#7AA2F7",
            bold = true,
        }

        hl.MiniStatuslineModeInsert = {
            fg = "#080A0F",
            bg = "#9ECE6A",
            bold = true,
        }

        hl.MiniStatuslineModeVisual = {
            fg = "#080A0F",
            bg = "#BB9AF7",
            bold = true,
        }

        hl.MiniStatuslineModeReplace = {
            fg = "#080A0F",
            bg = "#F7768E",
            bold = true,
        }

        hl.MiniStatuslineModeCommand = {
            fg = "#080A0F",
            bg = "#E0AF68",
            bold = true,
        }

        hl.MiniStatuslineFilename = {
            fg = "#A9B1D6",
            bg = "#0D1018",
        }

        hl.MiniStatuslineFileinfo = {
            fg = "#565F89",
            bg = "#0D1018",
        }

        -- mini.pick
        hl.MiniPickBorder = {
            fg = "#202638",
            bg = "#0D1018",
        }

        hl.MiniPickBorderText = {
            fg = "#7AA2F7",
            bg = "#0D1018",
            bold = true,
        }

        hl.MiniPickNormal = {
            fg = "#A9B1D6",
            bg = "#0D1018",
        }

        hl.MiniPickMatchCurrent = {
            bg = "#121722",
        }

        hl.MiniPickMatchMarked = {
            fg = "#7DCFFF",
        }

        hl.MiniPickMatchRanges = {
            fg = "#7AA2F7",
            bold = true,
        }
    end,
})

vim.cmd.colorscheme("tokyonight-night")
