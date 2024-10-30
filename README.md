# My NeoVim Setup

<p align="center">
  <img src="assets/AtroLogo.png" width="350" />
</p>

## Introduction

This is my neovim config. It has the common functionalities like LSP support, completion, formatters, linters and so on. It was made to be easily extendible, adding an LSP or a formatter should be very easy.

In addition user should be able to change some defaults and still being able to pull without nasty rebases. This nvim config accomplishes that.

## Instructions

Git clone this repo so that it sits at `~/.config/nvim`,

```bash
git clone https://github.com/atropos112/nvim.git ~/.config/nvim
```

this should work on any linux distro, and on Mac, I suspect also on WSL but I have not tried.

Once you have done this you will also need to install neovim, figure this out yourself its very OS dependent. Having this it should hopefully just work, I am low-key worried I have created un-intentional dependency on rust/go but heyho.

## How to extend/use

### Adding new plugin

In `lua/atro/plugins` find appropriate file and add a plugin in a typical LazyNvim way. If you need it to be dependent on global config, add/edit `lua/atro/config/defaults.lua` and possibly `lua/atro/config/types.lua` this will allow users to override those configs if they wish.

### Adding new lsp, formatter, linter

Simply edit `lua/atro/config/defaults.lua`, adding it for an appropriate language and it should be auto-installed (using mason) if a binary doesn't already exist.

There are edge cases where binary name and name of {lsp,formatter,linter} do not match. This is unfortunate but there isn't really a way around it other than manually adding this mapping (name to binary name) in `lua/atro/mason/mappings.lua` in the `M.to_bin` function.

### Overriding config

In a typical usage I don't expect a user to have to edit anything in the `nvim` dir, allowing user to pull in the future with ease as there is no conflicting changes with upstream.

To make overrides the user is expected to have `$HOME/.config/nvim-custom` directory. In that directory any `.lua` file will be executed **after** the global config `GCONF` has been created from the defaults. The user can then edit `GCONF` at will, edditing globals and keymaps is also advised. The configs in `GCONF` will then be used to set everything up.

If there are parts of the setup user wants to adjust and changing GCONF/globals alone is not sufficient, please make an issue/PR and this can be adjusted.

I use this at work where my needs differ drastically and yet having a relatively simple `nvim-custom` is all I need. If you are using this, this is the workflow I expect you to be able to achieve also.

## What is being worked on

I do not intend to change the structure significantly from now.

There are however plenty of plugins I added in the past, I didn't set up well enough and I certainly didn't comment/log well enough either, I need to fix this.

In addition there are still some plugins on my radar that I am considering adding.

## Useful links

[Events for auto-cmds](https://tech.saigonist.com/b/code/list-all-vim-script-events.html)

## Acklowledgement

I have gotten a lot of inspiration from [LunarVim](https://github.com/LunarVim/LunarVim), especially things like logging and the config concepts, thanks.
