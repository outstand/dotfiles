-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  _G.packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  -- Customizations
  use "rktjmp/lush.nvim"
  use "rktjmp/shipwright.nvim"
  use "ryansch/lunarized"
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use "folke/which-key.nvim"
  use 'mhinz/vim-startify'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
  }
  use 'tpope/vim-eunuch'
  use 'christoomey/vim-tmux-navigator'
  use {'pwntester/octo.nvim' }
  -- use 'sheerun/vim-polyglot'
  -- use "editorconfig/editorconfig-vim"
  use 'tpope/vim-rails'
  use 'tpope/vim-rake'
  use 'tpope/vim-rvm'
  use 'rafamadriz/friendly-snippets' -- TODO: Set up
  use 'sheerun/vim-polyglot'
  use 'outstand/logger.nvim'

  use 'nvim-lua/lsp-status.nvim'
  use 'mhartington/formatter.nvim'

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if _G.packer_bootstrap then
    require('packer').sync()
  end
end)

require('global')
require("treesitter").setup()
require("lsp").setup()
require("formatting").setup()

-- nvim-tree
local nvim_tree = require("nvim-tree")
nvim_tree.setup {
  auto_close = true,
}

-- which-key
local wk = require('which-key')
local t_builtin = require('telescope.builtin')
local function find_files()
  t_builtin.find_files({
    hidden = true,
    no_ignore = true,
  })
end
wk.setup {
  window = {
    border = "single"
  }
}
wk.register({
  f = {
    name = "telescope finders",
    b = { t_builtin.buffers, "Lists open buffers" },
    f = { find_files, "Find file" },
    h = { t_builtin.help_tags, "Lists available help tags " },
    t = { t_builtin.tags, "Lists tags in current directory " },
    g = { t_builtin.live_grep, "Search for a string" },
    ['?'] = { t_builtin.oldfiles, "Lists previously open files" },
  },
  l = {
    name = "telescope LSP",
    a = { t_builtin.diagostics, "Lists diagnostics" },
    d = { t_builtin.lsp_definitions, "Goto definition" },
    D = { t_builtin.lsp_type_definitions, "Goto type definition" },
    r = { t_builtin.lsp_references, "Lists LSP references" },
    i = { t_builtin.lsp_implementations, "Goto implementation" },
    s = { t_builtin.lsp_document_symbols, "Lists LSP document symbols" },
    w = { t_builtin.lsp_dynamic_workspace_symbols, "Dynamically Lists LSP for all workspace symbols" },
  },
  t = {
    name = "test runners",
  },
  d = {
    name = "debugger",
    l = {
      name = "lua",
      l = { "<Plug>(Luadev-RunLine)", "Execute the current line" },
      r = { "<Plug>(Luadev-Run)", "Execute lua code over a movement or text object" },
      w = { "<Plug>(Luadev-RunWord)", "Eval identifier under cursor" },
    },
  },
  r = {
    name = "runners",
    f = { "<cmd>Format<cr>", "Format" },
  },
  o = {
    name = "open",
    d = { function() nvim_tree.toggle(true) end, "Open directory" },
    f = { function() nvim_tree.find_file(true) end, "Focus file in directory" },
  },
}, { prefix = "<leader>" })

-- Diagnostic keymaps
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme lunarized]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Use visual bell
vim.o.visualbell = true

-- Automatically reload files changed outside of vim
vim.o.autoread = true

-- Enable system clipboard
vim.o.clipboard = "unnamedplus"

--Incremental live completion (note: this is now a default on master)
vim.o.inccommand = 'nosplit'

--Set highlight on search
vim.o.hlsearch = true

--Make line numbers default
vim.wo.number = true

--Do not save when switching buffers (note: this is now a default on master)
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.wo.signcolumn = 'yes'

-- Configure Beacon
vim.g.beacon_size = 90
vim.g.beacon_minimal_jump = 25
vim.g.beacon_ignore_filetypes = { "fzf" }

-- Setup cursorhold
-- vim.g.cursorhold_updatetime = 100

-- Create window splits easier. The default
-- way is Ctrl-w,v and Ctrl-w,s. I remap
-- this to vv and ss
vim.api.nvim_set_keymap('n', 'vv', '<C-w>v', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ss', '<C-w>s', { noremap = true, silent = true })

-- Clear current search highlight by double tapping //
vim.api.nvim_set_keymap('n', '//', ':nohlsearch<CR>', { silent = true })

--Set statusbar
local lunarized_lualine = require('lunarized.lualine')
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = lunarized_lualine,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', "require'lsp-status'.status()"},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

--Enable Comment.nvim
require('Comment').setup()

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

--Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- vim-startify
vim.g.startify_change_to_vcs_root = 1

if vim.fn.has('macunix') then
  vim.api.nvim_command('set rtp+=/opt/homebrew/opt/fzf')
end

-- gutentags
vim.g.gutentags_cache_dir = "~/.cache/gutentags"

-- Enable telescope fzf native
require('telescope').load_extension 'fzf'

-- vim: ts=2 sts=2 sw=2 et