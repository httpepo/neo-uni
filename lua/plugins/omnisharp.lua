local package_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h")
local sysname = vim.loop.os_uname().sysname
local machine = vim.loop.os_uname().machine

local cmd_bin
if sysname == "Darwin" then
  if machine == "arm64" then
    cmd_bin = package_root .. "/bin/omnisharp/osx-arm64/OmniSharp"
  else
    cmd_bin = package_root .. "/bin/omnisharp/osx-x64/OmniSharp"
  end
elseif sysname == "Windows_NT" then
  cmd_bin = package_root .. "/bin/omnisharp/win-x64/OmniSharp.exe"
else
  cmd_bin = package_root .. "/bin/omnisharp/linux-x64/OmniSharp"
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = {
          cmd = { cmd_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
          on_attach = function(client, bufnr)
            client.server_capabilities.inlayHintProvider = false
            if vim.lsp.inlay_hint then
              vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end
          end,
          settings = {
            omnisharp = {
              useModernNet = true,
            },
          },
        },
      },
    },
  },
}
