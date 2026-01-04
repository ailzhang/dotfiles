-- Neovim configuration (init.lua)
-- Converted from .vimrc with modern plugins

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- Plugin Setup
-- =============================================================================

require("lazy").setup({
  checker = { enabled = true },
  spec = {
    -- Color scheme
    {
      'tanvirtin/monokai.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme monokai]])
      end,
    },

    -- Status line (replaces vim-airline)
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup({
          options = {
            theme = 'monokai',
            section_separators = '',
            component_separators = '',
          },
          tabline = {
            lualine_a = { 'tabs' },
          },
        })
      end
    },

    -- File explorer (replaces NERDTree)
    {
      'nvim-tree/nvim-tree.lua',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('nvim-tree').setup({
          filters = { custom = { "^\\.git" } },
          live_filter = { always_show_folders = false },
        })
      end
    },

    -- Text alignment
    { 'godlygeek/tabular' },

    -- Markdown support
    {
      'plasticboy/vim-markdown',
      ft = { 'markdown' },
      config = function()
        vim.g.vim_markdown_folding_disabled = 1
      end
    },

    -- Git signs (replaces vim-gitgutter)
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup()
      end
    },

    -- Surround text manipulation
    {
      'kylechui/nvim-surround',
      event = 'VeryLazy',
      config = function()
        require('nvim-surround').setup()
      end
    },

    -- Indent markers
    {
      'folke/snacks.nvim',
      opts = {
        indent = {
          enabled = true,
          animate = { enabled = false },
        }
      },
    },

    -- Easy motion
    {
      'easymotion/vim-easymotion',
      config = function()
        vim.g.EasyMotion_do_mapping = 0
        vim.g.EasyMotion_smartcase = 1
        vim.keymap.set('n', 't', '<Plug>(easymotion-s2)')
      end
    },

    -- Treesitter for better syntax highlighting
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        -- In nvim 0.11+, treesitter highlight/indent are built-in
        -- nvim-treesitter is now mainly for parser management
        -- Parsers can be installed via :TSInstall <parser>
        -- or automatically via TSInstall command in build
      end
    },

    -- Better comments
    {
      'folke/ts-comments.nvim',
      event = 'VeryLazy',
      opts = {},
    },

    -- Telescope (replaces fzf.vim)
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-telescope/telescope-ui-select.nvim',
      },
      config = function()
        require('telescope').setup({
          defaults = {
            file_ignore_patterns = { "node_modules", ".git/" },
          },
        })
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('ui-select')
      end
    },

    -- GitHub URL copy
    {
      'ruifm/gitlinker.nvim',
      event = 'VeryLazy',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('gitlinker').setup({
          opts = { add_current_line_on_normal_mode = false },
          mappings = "<leader>gy"
        })
      end
    },

    -- Project root detection
    {
      'notjedi/nvim-rooter.lua',
      config = function()
        require('nvim-rooter').setup()
      end
    },

    -- ripgrep integration
    { 'jremmen/vim-ripgrep' },

    -- Mason for LSP server management
    {
      'williamboman/mason.nvim',
      config = function()
        require('mason').setup()
      end
    },

    -- Mason + lspconfig integration
    {
      'williamboman/mason-lspconfig.nvim',
      dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
      config = function()
        local servers = {
          "pyright",
          "ts_ls",
          "lua_ls",
          "jsonls",
          "yamlls",
        }

        require("mason-lspconfig").setup({
          ensure_installed = servers,
        })

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Configure each server using vim.lsp.config (nvim 0.11+)
        for _, lsp in ipairs(servers) do
          local config = { capabilities = capabilities }
          if lsp == "lua_ls" then
            config.settings = {
              Lua = { diagnostics = { globals = { 'vim' } } }
            }
          end
          vim.lsp.config(lsp, config)
        end

        -- Enable all configured servers
        vim.lsp.enable(servers)
      end
    },

    -- LSP config with keymaps
    {
      'neovim/nvim-lspconfig',
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true }),
          callback = function(event)
            local opts = { buffer = event.buf, silent = true }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)
          end,
        })
      end,
    },

    -- Auto format on save
    {
      'lukas-reineke/lsp-format.nvim',
      config = function()
        require('lsp-format').setup()
      end
    },

    -- Mason tool installer
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      config = function()
        require('mason-tool-installer').setup({
          auto_update = true,
          ensure_installed = {
            "bash-language-server",
            "pyright",
            "typescript-language-server",
            "lua-language-server",
            "json-lsp",
            "yaml-language-server",
            "black",
            "isort",
            "shellcheck",
            "shfmt",
          },
        })
      end
    },

    -- Completion engine
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
      },
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
          completion = {
            completeopt = 'menu,menuone,noinsert',
          },
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          }, {
            { name = 'buffer', keyword_length = 4 },
            { name = 'path' },
          })
        })

        -- Cmdline completions
        cmp.setup.cmdline('/', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = { { name = 'buffer' } }
        })

        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources(
            { { name = 'path' } },
            { { name = 'cmdline' } }
          )
        })
      end
    },
  }
})

-- =============================================================================
-- General Settings
-- =============================================================================

vim.opt.hidden = true
vim.opt.wrap = false
vim.opt.scrolloff = 15
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.shiftround = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.undofile = true
vim.opt.wildignore:append({ '*.pyc' })
vim.opt.title = true
vim.opt.wildmenu = true
vim.opt.wildmode = { 'list:longest', 'full' }
vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.encoding = 'utf-8'
vim.opt.mouse = 'a'
vim.opt.updatetime = 100
vim.opt.ttimeoutlen = 10
vim.opt.colorcolumn = ''
vim.opt.list = false
vim.opt.listchars = { extends = '#', precedes = '#', tab = '▸ ', eol = '¬' }

-- Treesitter folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99

-- =============================================================================
-- Keymaps
-- =============================================================================

-- Disable arrow keys
vim.keymap.set('n', '<Up>', '<NOP>')
vim.keymap.set('n', '<Down>', '<NOP>')
vim.keymap.set('n', '<Left>', '<NOP>')
vim.keymap.set('n', '<Right>', '<NOP>')

-- Clear search highlight
vim.keymap.set('n', '<CR>', '<cmd>nohlsearch<CR><CR>', { silent = true })
vim.keymap.set('n', '<leader><CR>', '<cmd>nohlsearch<CR>')

-- Quick save/quit
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>')

-- Toggle paste mode
vim.keymap.set('n', '<leader>p', '<cmd>set paste!<CR>')

-- Toggle list mode
vim.keymap.set('n', '<leader>l', '<cmd>set list!<CR>')

-- Tab width toggle
vim.keymap.set('n', '<leader>h', function()
  if vim.opt.tabstop:get() == 2 then
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    print("Tab width set to 4")
  else
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    print("Tab width set to 2")
  end
end)

-- Color column toggle
vim.keymap.set('n', '<leader>x', function()
  if vim.opt.colorcolumn:get()[1] then
    vim.opt.colorcolumn = ''
  else
    vim.opt.colorcolumn = '81'
  end
end)

-- Number toggle
vim.keymap.set('n', '<C-x>', function()
  if vim.opt.relativenumber:get() then
    vim.opt.number = true
    vim.opt.relativenumber = false
  else
    vim.opt.relativenumber = true
    vim.opt.number = false
  end
end)

-- Move by visual line
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- Alternative escape
vim.keymap.set('i', 'jk', '<ESC>')

-- Center search results
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- NvimTree toggle
vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeFindFileToggle<CR>')

-- Telescope mappings
vim.keymap.set('n', '<leader>te', '<cmd>Telescope<CR>')
vim.keymap.set('n', '<leader>f', '<cmd>Telescope find_files hidden=true<CR>')
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files hidden=true<CR>')
vim.keymap.set('n', '<leader>rg', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>t', '<cmd>Telescope tags<CR>')
vim.keymap.set('n', '<leader>fds', '<cmd>Telescope lsp_document_symbols<CR>')
vim.keymap.set('n', '<C-p>', '<cmd>Telescope git_files<CR>')
vim.keymap.set('i', '<C-p>', '<cmd>Telescope git_files<CR>')

-- Open file in current file's directory
vim.keymap.set('c', '%%', function()
  return vim.fn.expand('%:h') .. '/'
end, { expr = true })
vim.keymap.set('n', '<leader>ew', ':e %%')
vim.keymap.set('n', '<leader>et', ':tabe %%')

-- =============================================================================
-- Autocommands
-- =============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespace on save
augroup('TrailingWhitespace', { clear = true })
autocmd('BufWritePre', {
  group = 'TrailingWhitespace',
  pattern = '*',
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Switch to absolute numbers on focus/insert
augroup('NumberToggle', { clear = true })
autocmd({ 'FocusLost', 'InsertEnter' }, {
  group = 'NumberToggle',
  callback = function()
    vim.opt.number = true
    vim.opt.relativenumber = false
  end,
})
autocmd({ 'FocusGained', 'InsertLeave' }, {
  group = 'NumberToggle',
  callback = function()
    vim.opt.relativenumber = true
    vim.opt.number = false
  end,
})

-- Compile LaTeX on save
augroup('LaTeX', { clear = true })
autocmd('BufWritePost', {
  group = 'LaTeX',
  pattern = '*.tex',
  command = 'silent !make >/dev/null 2>&1 &',
})

-- =============================================================================
-- Commands
-- =============================================================================

vim.api.nvim_create_user_command('Wrap', 'set wrap linebreak nolist', {})
