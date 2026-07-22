-- bootstrap lazy.nvim, LazyVim and your plugins
local package_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.opt.rtp:prepend(package_root)
require("config.lazy")
