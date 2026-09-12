return {
  {
    "3rd/image.nvim",
    lazy = false,
    opts = {
      backend = "kitty",
      processor = "magick_cli",

      integrations = {
        markdown = {
          enabled = false,
        },
      },

      hijack_file_patterns = {
        "*.png",
        "*.jpg",
        "*.jpeg",
        "*.gif",
        "*.webp",
        "*.avif",
      },
    },
  },

  {
    "3rd/diagram.nvim",
    dependencies = {
      "3rd/image.nvim",
    },
    config = function()
      require("diagram").setup({
        integrations = {
          require("diagram.integrations.markdown"),
        },

        renderer_options = {
          mermaid = {
            background = "transparent",
            theme = "dark",
            scale = 1,

            cli_args = {
              "-p",
              vim.fn.expand("~/.config/mermaid/puppeteer.json"),
            },
          },
        },
      })
    end,
  },
}
