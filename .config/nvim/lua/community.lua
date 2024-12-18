---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.color.transparent-nvim" },
  { import = "astrocommunity.search.nvim-spectre" },

  -- import/override with your plugins folder
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.fish" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.rust" },
  -- { import = "astrocommunity.markdown-and-latex.markview-nvim" },

  { import = "astrocommunity.lsp.lsp-lens-nvim" },
  { import = "astrocommunity.recipes.telescope-lsp-mappings" },

  { import = "astrocommunity.motion.nvim-surround" },

  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },

  { import = "astrocommunity.git.git-blame-nvim" },
  { import = "astrocommunity.terminal-integration.flatten-nvim" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.completion.copilot-lua" },

  { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.scrolling.neoscroll-nvim" },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    opts = function(_, opts)
      local cmp, copilot = require "cmp", require "copilot.suggestion"
      local snip_status_ok, luasnip = pcall(require, "luasnip")
      if not snip_status_ok then return end
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end
      if not opts.mapping then opts.mapping = {} end
      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if copilot.is_visible() then
          copilot.accept()
        elseif cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" })

      opts.mapping["<C-x>"] = cmp.mapping(function()
        if copilot.is_visible() then copilot.next() end
      end)

      opts.mapping["<C-z>"] = cmp.mapping(function()
        if copilot.is_visible() then copilot.prev() end
      end)

      opts.mapping["<C-right>"] = cmp.mapping(function()
        if copilot.is_visible() then copilot.accept_word() end
      end)

      opts.mapping["<C-down>"] = cmp.mapping(function()
        if copilot.is_visible() then copilot.accept_line() end
      end)

      opts.mapping["<C-c>"] = cmp.mapping(function()
        if copilot.is_visible() then copilot.dismiss() end
      end)

      opts.filetypes = {
        markdown = true,
        yaml = true,
      }

      return opts
    end,
  },
  { import = "astrocommunity.utility.nvim-toggler" },

  { import = "astrocommunity.test.nvim-coverage" },
}
