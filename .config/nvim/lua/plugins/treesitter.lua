if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "luap",
      "vim",
      "typescript",
      "markdown",
      "markdown_inline",
      "javascript",
      "typescript",
      "tsx",
      "jsdoc",
      "yaml",
      "json",
      "jsonc",
      "html",
      "css",
      "toml",
    },
  },
}
