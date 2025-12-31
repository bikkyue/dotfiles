return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()

    require("bufferline").setup{
      options = {
        separator_style = "thin",
        show_buffer_close_icons = false,
        show_close_icon = false,
        offsets = { { filetype = "NvimTree", text = "File Explorer", padding = 1 } },
      }
    }
  end,
}