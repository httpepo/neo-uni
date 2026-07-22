return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    -- Basic settings
    smear_between_buffers = true, -- Smear when switching buffers
    smear_insert_mode = true,     -- Keep the trail active in insert mode
    
    -- Optional override if your terminal blocks Neovim cursor colors
    -- cursor_color = "#d3cdc3", 
  },
}

