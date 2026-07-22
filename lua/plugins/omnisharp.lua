return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = {
          on_attach = function(client, bufnr)
            client.server_capabilities.inlayHintProvider = false
            if vim.lsp.inlay_hint then
              vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end
          end,
          capabilities = {
            textDocument = {
              inlayHint = vim.NIL,
            },
          },
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
