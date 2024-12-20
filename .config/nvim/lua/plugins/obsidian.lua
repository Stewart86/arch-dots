return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "notes",
        path = "~/Documents/Notes/",
      },
    },

    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      template = nil,
    },

    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function() return require("obsidian").util.gf_passthrough() end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>ch"] = {
        action = function() return require("obsidian").util.toggle_checkbox() end,
        opts = { buffer = true },
      },

      -- list daily notes
      ["<leader>al"] = {
        action = "<cmd>ObsidianDailies<cr>",
        desc = "List daily notes",
      },

      -- create today daily note
      ["<leader>at"] = {
        action = "<cmd>ObsidianToday<cr>",
        desc = "Today's note",
      },

      -- create tomorrow daily note
      ["<leader>am"] = {
        action = "<cmd>ObsidianTomorrow<cr>",
        desc = "Tomorrow's note",
      },
    },

    ui = {
      enable = false, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      -- Define how various check-boxes are displayed
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },

        -- You can also add more custom ones...
      },
      -- Use bullet marks for non-checkbox lists.
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },
  },
}
