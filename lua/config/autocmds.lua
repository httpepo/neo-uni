-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Automatically register Neovim package dependency in Unity manifest.json
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*.cs",
  callback = function()
    local path = vim.fn.findfile("Packages/manifest.json", vim.fn.expand("%:p:h") .. ";")
    if path == "" then
      return
    end

    local file = io.open(path, "r")
    if not file then
      return
    end
    local content = file:read("*a")
    file:close()

    if not string.find(content, "com.pedro.neovim") then
      local updated, count = string.gsub(
        content,
        '"dependencies":%s*{',
        '"dependencies": {\n    "com.pedro.neovim": "file:/Users/pedrohenriquesudariodasilva/unity-neovim-package",'
      )
      if count > 0 then
        file = io.open(path, "w")
        if file then
          file:write(updated)
          file:close()
          vim.notify("Unity project linked with Neovim Package Integration!", vim.log.levels.INFO)
        end
      end
    end
  end,
})

