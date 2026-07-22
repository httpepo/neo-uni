return {
  "andweeb/presence.nvim",
  config = function()
    local file_assets = {
      [""] = { "neovim", "Neovim", "The One True Text Editor" },
      ["[No Name]"] = { "neovim", "Neovim", "The One True Text Editor" },
    }

    setmetatable(file_assets, {
      __index = function(t, key)
        if key == "" or key == "[No Name]" then
          return { "neovim", "Neovim", "The One True Text Editor" }
        else
          return nil
        end
      end
    })

    local presence = require("presence")
    local original_get_filename = presence.get_filename
    presence.get_filename = function(path, path_separator)
      if not path or path == "" then
        return "[No Name]"
      end
      local result = original_get_filename(path, path_separator)
      return (result == nil or result == "") and "[No Name]" or result
    end

    local is_sleeping = false
    local sleep_timer = (vim.uv or vim.loop).new_timer()

    local function reset_sleep_timer()
      if is_sleeping then
        is_sleeping = false
        if presence.last_activity then
          presence.last_activity.file = nil
        end
        presence:update()
      end
      sleep_timer:stop()
      sleep_timer:start(10800000, 0, vim.schedule_wrap(function()
        is_sleeping = true
        if presence.last_activity then
          presence.last_activity.file = nil
        end
        presence:update()
      end))
    end

    presence.setup({
      auto_update = true,
      log_level = nil,
      editing_text = function(filename)
        if is_sleeping then
          return "sleeping - left Neovim open"
        end
        if filename == "" or filename == "[No Name]" or filename == "nil" then
          return "☕ 💤 brewing coffee"
        end
        return string.format("Coding %s", filename)
      end,
      reading_text = function(filename)
        if is_sleeping then
          return "sleeping - left Neovim open"
        end
        if filename == "" or filename == "[No Name]" or filename == "nil" then
          return "☕ 💤 brewing coffee"
        end
        return string.format("Reading %s", filename)
      end,
      workspace_text = "In project %s",
      main_image = "file",
      file_assets = file_assets,
    })

    -- Override set_activity to dynamically adjust assets for idle/sleep states
    if presence.discord then
      local original_set_activity = presence.discord.set_activity
      presence.discord.set_activity = function(self_discord, activity, callback)
        if activity and activity.assets then
          if activity.details == "☕ 💤 brewing coffee" or activity.details == "sleeping - left Neovim open" then
            activity.assets.small_image = nil
            activity.assets.small_text = nil
            activity.assets.large_image = "neovim"
          end
        end
        return original_set_activity(self_discord, activity, callback)
      end
    end

    -- Setup autocommands for activity detection
    local sleep_group = vim.api.nvim_create_augroup("PresenceSleep", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI", "BufEnter", "FocusGained" }, {
      group = sleep_group,
      callback = function()
        reset_sleep_timer()
      end,
    })

    -- Start initial timer
    reset_sleep_timer()
  end,
}
