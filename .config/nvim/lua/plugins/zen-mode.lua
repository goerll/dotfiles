return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    window = {
      width = 120,
      height = 0.90,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = "0",
        list = false,
      },
    },
    plugins = {
      gitsigns = { enabled = true },
      tmux = { enabled = true },
      kitty = { enabled = true },
      twilight = { enabled = true },
      alacritty = {
        enabled = true,
        font = "14",
      },
    },
    on_open = function(_)
      -- Optional: run commands when zen mode opens
    end,
    on_close = function()
      -- Optional: run commands when zen mode closes
    end,
  },
  config = function(_, opts)
    require("zen-mode").setup(opts)

    -- Keybinding
    vim.keymap.set("n", "<leader>z", function()
      require("zen-mode").toggle()
    end, { desc = "Toggle Zen Mode" })
  end,
}
