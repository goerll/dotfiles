return {
    {"catppuccin/nvim", name = "catpuccin", priority = 1000},
    {"navarasu/onedark.nvim", style = "deep"},
    {"shaunsingh/moonlight.nvim"},
    {"nyoom-engineering/oxocarbon.nvim"},
    {"marko-cerovac/material.nvim", style = "deep ocean"},
    {"projekt0n/github-nvim-theme"},
    {"folke/tokyonight.nvim", style = "night"},
    {"shrikecode/kyotonight.vim"},
    {"diegoulloao/neofusion.nvim"},
    {"Domeee/mosel.nvim"},
    {'olivercederborg/poimandres.nvim'},
    { 'datsfilipe/vesper.nvim' },

    -- Warm Green-ish Themes
    {"xero/miasma.nvim"},
    {"bjarneo/pixel.nvim"},
    -- {"comfysage/evergarden"},
    {
    "comfysage/evergarden",
    name = "evergarden",
    priority = 1000,
    opts = {
        theme = {
        variant = "winter", -- or "winter"|"spring"|"summer"
        accent = "green",
        },
        editor = {
        transparent_background = true,  -- <-- enable transparency
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

    {"sainnhe/everforest"},
    {'ribru17/bamboo.nvim'},
    {'neanias/everforest-nvim'},

    {'sho-87/kanagawa-paper.nvim'},

    -- Make background transparent (not an actual colorscheme)
    {"xiyaowong/transparent.nvim"},
}
