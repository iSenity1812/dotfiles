return {
  ---------------------------------------------------------------------------
  -- Image paste / drag & drop
  ---------------------------------------------------------------------------
  {
    "HakonHarnes/img-clip.nvim",
    lazy = false,

    opts = {
      default = {
        ---------------------------------------------------------------------
        -- Resolve attachment directory
        ---------------------------------------------------------------------
        dir_path = function()
          local current_file = vim.api.nvim_buf_get_name(0)

          if current_file == "" then
            return "assets"
          end

          local current_dir = vim.fn.fnamemodify(current_file, ":h")

          local marker = vim.fs.find({
            ".node-root",
            ".notes-root",
            ".git",
          }, {
            path = current_dir,
            upward = true,
            stop = vim.env.HOME,
          })[1]

          if not marker then
            return "assets"
          end

          local root = vim.fs.dirname(marker)
          local assets_abs = root .. "/assets"

          vim.fn.mkdir(assets_abs, "p")

          local relative = vim.fn.system({
            "realpath",
            "--relative-to=" .. current_dir,
            assets_abs,
          })

          if vim.v.shell_error ~= 0 then
            vim.notify("Không tính được relative assets path", vim.log.levels.WARN)

            return "assets"
          end

          relative = vim.trim(relative)

          if relative == "" then
            return "assets"
          end

          return relative
        end,

        ---------------------------------------------------------------------
        -- Markdown path behavior
        ---------------------------------------------------------------------
        use_absolute_path = false,
        relative_to_current_file = true,

        ---------------------------------------------------------------------
        -- Clipboard screenshot naming
        ---------------------------------------------------------------------
        file_name = "%Y-%m-%d-%H-%M-%S",
        extension = "png",

        ---------------------------------------------------------------------
        -- External image files
        ---------------------------------------------------------------------
        copy_images = true,

        formats = {
          "png",
          "jpg",
          "jpeg",
          "webp",
          "gif",
          "bmp",
          "avif",
        },

        ---------------------------------------------------------------------
        -- UI
        ---------------------------------------------------------------------
        prompt_for_file_name = false,
        show_dir_path_in_prompt = false,

        ---------------------------------------------------------------------
        -- IMPORTANT:
        --
        -- Disable img-clip's built-in drag & drop.
        -- It overrides vim.paste() and interferes with Ctrl+Shift+V text.
        --
        -- We implement our own drag handling below instead.
        ---------------------------------------------------------------------
        drag_and_drop = {
          enabled = false,
        },
      },

      -----------------------------------------------------------------------
      -- Markdown rendering syntax
      -----------------------------------------------------------------------
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          download_images = false,
        },
      },
    },

    config = function(_, opts)
      local img_clip = require("img-clip")

      img_clip.setup(opts)

      -----------------------------------------------------------------------
      -- Keep original Neovim paste behavior
      -----------------------------------------------------------------------
      local original_vim_paste = vim.paste

      -----------------------------------------------------------------------
      -- Helpers
      -----------------------------------------------------------------------

      local function uri_decode(uri)
        uri = vim.trim(uri)
        uri = uri:gsub("\r$", "")
        uri = uri:gsub("^file://", "")

        return uri:gsub("%%(%x%x)", function(hex)
          return string.char(tonumber(hex, 16))
        end)
      end

      local function is_image_file(path)
        if vim.fn.filereadable(path) ~= 1 then
          return false
        end

        local ext = path:match("%.([^./]+)$")

        if not ext then
          return false
        end

        ext = ext:lower()

        local supported = {
          png = true,
          jpg = true,
          jpeg = true,
          webp = true,
          gif = true,
          bmp = true,
          avif = true,
        }

        return supported[ext] == true
      end

      local function normalize_dropped_path(value)
        value = vim.trim(value)
        value = value:gsub("\r$", "")

        -- file:///home/user/image.png
        if value:match("^file://") then
          value = uri_decode(value)
        end

        -- '/home/user/image.png'
        -- "/home/user/image.png"
        if (value:sub(1, 1) == "'" and value:sub(-1) == "'") or (value:sub(1, 1) == '"' and value:sub(-1) == '"') then
          value = value:sub(2, -2)
        end

        -- /home/user/My\ Image.png
        value = value:gsub("\\ ", " ")

        return value
      end

      local function get_clipboard_types()
        local output = vim.fn.system({
          "wl-paste",
          "--list-types",
        })

        if vim.v.shell_error ~= 0 then
          error("Không đọc được Wayland clipboard")
        end

        return output
      end

      local function get_file_from_clipboard()
        local output = vim.fn.system({
          "wl-paste",
          "--type",
          "text/uri-list",
        })

        if vim.v.shell_error ~= 0 or output == "" then
          return nil
        end

        local lines = vim.split(output, "\n", {
          trimempty = true,
        })

        for _, line in ipairs(lines) do
          line = vim.trim(line)
          line = line:gsub("\r$", "")

          if not line:match("^#") and line:match("^file://") then
            return uri_decode(line)
          end
        end

        return nil
      end

      -----------------------------------------------------------------------
      -- Paste an existing image file
      --
      -- Keep original filename:
      --
      -- architecture-old.png
      --      ↓
      -- assets/architecture-old.png
      -----------------------------------------------------------------------

      local function paste_existing_image(path)
        if not is_image_file(path) then
          error("File không phải image được hỗ trợ: " .. path)
        end

        local filename = vim.fn.fnamemodify(path, ":t")

        img_clip.paste_image({
          copy_images = true,
          file_name = filename,
        }, path)
      end

      -----------------------------------------------------------------------
      -- Smart clipboard paste
      --
      -- Space i p
      -----------------------------------------------------------------------

      local function smart_paste_image()
        local current_file = vim.api.nvim_buf_get_name(0)

        if current_file == "" then
          error("Hãy lưu Markdown file trước khi paste image")
        end

        local types = get_clipboard_types()

        ---------------------------------------------------------------------
        -- Screenshot / browser Copy Image
        --
        -- No original filename exists, so timestamp is appropriate.
        ---------------------------------------------------------------------

        if types:match("image/") then
          img_clip.paste_image()
          return
        end

        ---------------------------------------------------------------------
        -- Ctrl+C an image file from Nautilus
        ---------------------------------------------------------------------

        if types:match("text/uri%-list") then
          local src = get_file_from_clipboard()

          if not src then
            error("Không lấy được file từ clipboard")
          end

          if vim.fn.filereadable(src) ~= 1 then
            error("File không tồn tại: " .. src)
          end

          paste_existing_image(src)

          return
        end

        error("Clipboard không chứa image. " .. "Hãy Copy Image, screenshot, hoặc Ctrl+C một image file.")
      end

      -----------------------------------------------------------------------
      -- Safe runner
      -----------------------------------------------------------------------

      local function run_smart_paste()
        local ok, err = xpcall(smart_paste_image, debug.traceback)

        if not ok then
          vim.notify(err, vim.log.levels.ERROR, {
            title = "Paste Image",
          })
        end
      end

      -----------------------------------------------------------------------
      -- Custom drag & drop
      --
      -- Ghostty sends a dropped file path through vim.paste().
      --
      -- If it is an image:
      --   → img-clip handles it
      --
      -- If it is normal text:
      --   → fall back to Neovim's original paste
      --
      -- This keeps Ctrl+Shift+V text working normally.
      -----------------------------------------------------------------------

      vim.paste = function(lines, phase)
        local content = table.concat(lines, "\n")
        local path = normalize_dropped_path(content)

        if is_image_file(path) then
          local ok, err = xpcall(function()
            paste_existing_image(path)
          end, debug.traceback)

          if not ok then
            vim.notify(err, vim.log.levels.ERROR, {
              title = "Drag Image",
            })
          end

          return true
        end

        return original_vim_paste(lines, phase)
      end

      -----------------------------------------------------------------------
      -- Command
      -----------------------------------------------------------------------

      vim.api.nvim_create_user_command("PasteImageSmart", run_smart_paste, {})

      -----------------------------------------------------------------------
      -- Keymap
      --
      -- Space i p
      -----------------------------------------------------------------------

      vim.keymap.set("n", "<leader>ip", run_smart_paste, {
        desc = "Paste image",
        silent = true,
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- Render images
  ---------------------------------------------------------------------------
  {
    "folke/snacks.nvim",

    opts = {
      image = {
        enabled = true,
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Render Markdown
  ---------------------------------------------------------------------------
  {
    "MeanderingProgrammer/render-markdown.nvim",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.nvim",
    },

    opts = {
      html = {
        enabled = true,

        tag = {
          red = {
            scope_highlight = "MarkdownRed",
          },

          green = {
            scope_highlight = "MarkdownGreen",
          },

          yellow = {
            scope_highlight = "MarkdownYellow",
          },

          blue = {
            scope_highlight = "MarkdownBlue",
          },

          dim = {
            scope_highlight = "MarkdownDim",
          },
        },
      },
    },

    init = function()
      vim.api.nvim_set_hl(0, "MarkdownRed", {
        link = "DiagnosticError",
      })

      vim.api.nvim_set_hl(0, "MarkdownYellow", {
        link = "DiagnosticWarn",
      })

      vim.api.nvim_set_hl(0, "MarkdownGreen", {
        link = "DiagnosticOk",
      })

      vim.api.nvim_set_hl(0, "MarkdownBlue", {
        link = "DiagnosticInfo",
      })

      vim.api.nvim_set_hl(0, "MarkdownDim", {
        link = "Comment",
      })
    end,
  },
}
