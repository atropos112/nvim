# My NeoVim Setup

<p align="center">
  <img src="assets/AtroLogo.png" width="350" />
</p>

## Introduction

This is my neovim config. It is a work in progress and I am constantly updating it. It uses lua exclusively, it has lsp's , linters, formatters (which format on save) and many other comforts of life. Its still somewhat messy an inconsistent however.

## Instructions

Git clone this repo so that it sits at `~/.config/nvim`,

```bash
git clone https://github.com/atropos112/nvim.git ~/.config/nvim
```

this should work on any linux distro, and on Mac, I suspect also on WSL but I have not tried.

Once you have done this you will also need to install neovim, figure this out yourself its very OS dependent. Having this it should hopefully just work, I am low-key worried I have created un-intentional dependency on rust/go but heyho.

## How to extend/use

This setup is composed of

- `lua/atro/plugins`: Lazy plugins of all sorts, with their corresponding configs, usually lazy loaded.
- `lua/atro/installer`: Is a utility directory that knows what needs to be installed.
- `lua/atro/utils`: Utils for general usage.
- `lua/atro/{lsp,dap,fmt,lint}`: Are setups for the corresponding matter, LSPs, DAPs, FMTs and linters get loaded and configured there and can all be overriden using override files in the corresponding dirs.

## To do

This config was written with future expansion in mind as well as flexibility of overriding.
Functionally it can do both pretty well, from usability standpoint it sucks. Currently I know how to do all of
it, in few months unlikely to be the case. To address this I need to

- Simplify and document overriding, LSPs, linters, FMTs and DAPs can be overriden and "main" configs can be set. It is confusing what is "main" config and what is LSP etc., need to unify or create obvious boundaries and document it.

- Expanding is actually built out, it used to be very complicated now its only a little bit complicated, would like to simplify further but not sure how or if its possible while keeping future expandability. I need to document how to add new LSPs, new FMTs etc.

- There is quiet a lot of plugins on my radar, I would like investigate and potentially add more to my config.

## Useful links

[Events for auto-cmds](https://tech.saigonist.com/b/code/list-all-vim-script-events.html)
