return {
    -- Main theme (highest priority)
    {
        "comfysage/evergarden",
        name = "evergarden",
        priority = 1000,
        lazy = false,
        opts = {
            theme = {
                variant = "winter", -- or "winter"|"spring"|"summer"
                accent = "green",
            },
            editor = {
                transparent_background = true,
                override_terminal = true,
                sign = { color = "none" },
                float = { color = "mantle", invert_border = false },
                completion = { color = "surface0" },
            },
        },
        config = function(_, opts)
            require("evergarden").setup(opts)
            vim.cmd("colorscheme evergarden")
        end,
    },

    -- Alternative themes (can be switched to)
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 999,
        lazy = true,
        opts = {
            flavour = "auto", -- latte, frappe, macchiato, mocha
            background = {
                light = "latte",
                dark = "mocha",
            },
            transparent_background = true,
            term_colors = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                telescope = true,
                notify = true,
                mini = true,
            },
        },
    },

    {
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 998,
        opts = {
            style = "night",
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
    },

    {
        "navarasu/onedark.nvim",
        lazy = true,
        priority = 997,
        opts = {
            style = "deep",
            transparent = true,
            lualine = {
                transparent = true,
            },
        },
    },

    {
        "neanias/everforest-nvim",
        lazy = true,
        priority = 996,
        opts = {
            background = "hard",
            transparent_background_level = 1,
        },
    },
}
