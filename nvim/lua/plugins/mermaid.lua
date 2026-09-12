return {
  {
    "kevalin/mermaid.nvim",

    ft = {
      "markdown",
      "mermaid",
    },

    opts = {
      preview = {
        auto_open = true,
      },
    },

    keys = {
      {
        "<leader>mv",
        "<cmd>MermaidPreview<cr>",
        desc = "Mermaid view",
      },
      {
        "<leader>mV",
        "<cmd>MermaidPreviewStop<cr>",
        desc = "Stop Mermaid view",
      },
      {
        "<leader>mu",
        "<cmd>MermaidCopyURL<cr>",
        desc = "Copy Mermaid preview URL",
      },
    },
  },
}
