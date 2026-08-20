return {
  {
    "uZer/pywal16.nvim",
    config = function()
      vim.cmd.colorscheme("pywal16")

      local colors_file = vim.fn.expand("~/.cache/wal/colors.json")

      local function reload_theme()
        vim.defer_fn(function()
          vim.schedule(function()
            vim.cmd.colorscheme("pywal16")
          end)
        end, 100)
      end

      local watcher = vim.loop.new_fs_event()
      if watcher then
        watcher:start(colors_file, {}, function(err)
          if not err then
            reload_theme()
          end
        end)

        vim.api.nvim_create_autocmd("VimLeave", {
          callback = function()
            watcher:close()
          end,
        })
      end
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      -- tu configuración existente
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Cambia el color de archivos ocultos
      vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#ffffff" })
    end,
  },
}
