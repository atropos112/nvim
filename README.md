# My NeoVim Setup 

I think its fair to say, my neovim setup is basic if we are being polite and shit if not. Its WIP.


# Adding support for new language
Adding new language functionality is about syntax highlighting, LSP support, test support, debug support.

1. Syntax highlighting is automatically done by TreeSitter, **fully automated, no action required**.
2. LSP can be installed via `:Mason` or `:MasonInstall` if you know exact LSP server name. For special configs edit `lsp.lua` file otherwise **after LSP install, no config change required**. 
3. Debugging (DAP) is the annoying part as it requires adapter and configuration to be added to the `dap.lua` file, this seems to vary from language to language so you gotta figure this one out by yourself.
4. Testing is done via Neotest, go to `neotest.lua` and add required runner there, that should be it. 
