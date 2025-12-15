return {
    "matze/vim-move",
    keys = { "<M-j>", "<M-k>", "<A-j>", "<A-k>" }, -- Lazy load on key press
    config = function()
        -- Configure vim-move options
        vim.g.move_key_modifier = 'Alt' -- Use Alt key for moving lines
        vim.g.move_key_modifier_visualmode = 'Alt'
        vim.g.move_block_keys = '[]' -- Key for block-wise movement
    end,
}
