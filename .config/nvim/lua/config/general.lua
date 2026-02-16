-- General options
local opt = vim.opt

-- Indentation
opt.tabstop = 4 -- TAB looks like 4 spaces
opt.softtabstop = 4 -- 4 spaces inserted instead of TAB
opt.shiftwidth = 4 -- 4 spaces when indenting
opt.expandtab = true -- TAB key inserts spaces instead of TAB
opt.shiftround = true -- Indent rounds to shift width
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true -- Wrap indent to match line start

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "both" -- Highlight both line number and content

-- Hybrid line numbers: relative by default, absolute on current line
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  pattern = "*",
  callback = function()
    if vim.opt.relativenumber:get() then
      vim.opt.number = true
    end
  end,
})

-- Search
opt.ignorecase = true -- Case insensitive searching
opt.smartcase = true -- Case-sensitive if capital letters present
opt.hlsearch = false -- Don't highlight search results
opt.incsearch = true -- Show search results as you type

-- Scrolling
opt.scrolloff = 8 -- Keep 8 lines visible when scrolling
opt.sidescrolloff = 8 -- Keep 8 columns visible horizontally
opt.smoothscroll = true -- Smooth scrolling

-- Display
opt.termguicolors = true -- Enable true color support
opt.signcolumn = "yes" -- Always show sign column
opt.showmode = false -- Don't show mode in command line (we have statusline)
opt.showcmd = true -- Show command in status line
opt.cmdheight = 0 -- Hide command line when not used
opt.laststatus = 3 -- Global statusline
opt.pumheight = 10 -- Maximum number of items in popup menu

-- Editor behavior
opt.undofile = true -- Persistent undo
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup before overwriting
opt.swapfile = false -- Don't use swapfile
opt.confirm = true -- Confirm before saving changes
opt.autowrite = true -- Automatically write when switching buffers
opt.autoread = true -- Automatically read changes from outside

-- Mouse and selection
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "" -- Use system clipboard (handled by keymaps)
opt.selection = "exclusive"
opt.selectmode = "mouse"

-- Window splitting
opt.splitright = true -- Split vertical windows to the right
opt.splitbelow = true -- Split horizontal windows below
opt.fillchars:append({
  vert = "│",
  fold = " ",
  eob = " ", -- Hide end-of-buffer tildes
  diff = "╱",
})

-- Folding
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- GUI specific
if vim.g.gui_vimr or vim.g.neovide then
  opt.guifont = "GeistMono Nerd Font:h12"
end

-- Performance
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.updatetime = 200
