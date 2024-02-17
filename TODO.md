# Needs documenting

1. Gitsigns details 
    - https://github.com/lewis6991/gitsigns.nvim?tab=readme-ov-file

2. Neotree detailed setup with keymaps
    - https://github.com/nvim-neo-tree/neo-tree.nvim
    - https://github.com/iabdelkareem/dotfiles/blob/main/.config/nvim/lua/core/file-tree.lua
    - https://invidious.atro.xyz/watch?v=GVk387iCyhY

3. Diffview keymaps and figure out what does what
    - https://github.com/sindrets/diffview.nvim?tab=readme-ov-file
    - https://invidious.atro.xyz/watch?v=SWldGqw9wkc


--- 
1. How did you "make" each language "work"
    - For C# explain how https://github.com/Hoffs/omnisharp-extended-lsp.nvim was needed to allow go-def to work on non-owned code (decompiled). This really needs to be documented, the `~/.omnisharp/omnisharp.json`
    - For Go explain how you use a package and all works

2. Neoformat in need of further investigation.

3. Mason has all the DAP's and LSP's that I needed, but they are manually installed, would be good to have ensure_installed and have them there.

4. More research needed
    - Into youtube videos
    - Other's peoples work. 

5. Document somewhere all my defined keymaps, `:nmap`, `:vmap`, `:imap` can help with this. 
    - Document window jumping `<C-w>` followed by arrows/hjkl.
    - Document window resizing `<C-w>` followed by +/- for vertical increase/decrease and >/< for horizontal increase/decrease.

6. Add [Json Schema support](https://www.arthurkoziel.com/json-schemas-in-neovim/).

7. Add [NeoTest](https://github.com/nvim-neotest/neotest) keymaps

8. Utilize `after/ftplugin` (see [here](https://github.com/garcia5/dotfiles/tree/master/files/nvim) for example)

9. Make it NixOS compatible by having it work as a separate flake that I can expose publicly, for example of this being done check [here](https://github.com/ayamir/nvimdots?tab=readme-ov-file).
