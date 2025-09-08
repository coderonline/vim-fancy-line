# vim-fancy-line

This statusline is kept minimalistic and easy to understand. Its main feature
is, that it uses Vims highlight groups correctly and displays the status-
and tab-bar after the definitions in the currently selected colorscheme.
That means, that the highlight groups `StatusLine`, `StatusLineNC`,
`StatusLineTerm` and `StatusLineTermNC` are considered. Otherwise the bars
look similar to powerline, but that is no wonder, because the `` symbol
is the only one, which used to be available in code page 437 and thus broadly
compatible.

![screenshot](https://git.entwicklerseite.de/vim-fancy-line/plain/screenshot.png)


## TLDR;

Key features:

* Compatible (at least) with all pre-installed colorschemes
* Pure Vimscript, no overhead (this is critical with statuslines, because textlock is active during stl updates)
* Displays the tab bar in a different color for the `root` user: `:highlight Error`


## Configuration

* It should be considered to add `showtabline=2` to the vimrc
* It looks nicer with proper fillchars, e.g. `fillchars+=eob:\ ,vert:\`


## Installation

This should be sufficient:

    git clone https://git.entwicklerseite.de/vim-fancy-line \
        ~/.vim/pack/coderonline/start/vim-fancy-line

Or as submodule:

    git submodule add https://git.entwicklerseite.de/vim-fancy-line \
        ~/.vim/pack/coderonline/start/vim-fancy-line

Or download the zip file and extract it under `~/.vim/pack/coderonline/start/`.

## Installation using plugin managers

### vim-plug

    Plug 'coderonline/vim-fancy-line'

### dein.vim

    call dein#add('coderonline/vim-fancy-line')

## Design goals

* Keep it simple
