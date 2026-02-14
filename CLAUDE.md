# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository containing bash, vim, tmux, and git configuration. Files are stored without the leading dot (e.g., `bashrc` not `.bashrc`).

## Setup

Run `bash setup.bash` from the repo root to symlink all dotfiles into `$HOME` (strips the dot prefix automatically) and install vim plugins (pathogen, ag.vim, fugitive, ctrlp).

## Key Conventions

- **Shell**: bash with vi mode (`set -o vi`), prefix `C-a` in tmux
- **Editor**: vim with pathogen plugin management; plugins live in `~/.vim/bundle/`
- **Indentation defaults**: 4 spaces (expandtab), except C/C++ which uses 8-width hard tabs
- **Platform handling**: bashrc detects Linux vs macOS for ls color differences

## File Descriptions

- `bashrc` - Shell config: custom PS1 prompt with git branch/exit code, aliases, PATH setup, vi keybindings
- `vimrc` - Vim config: filetype-specific indent rules, cscope integration, pathogen plugins, key mappings (`jj` for Esc, `;` for `:`, `mm` for `:qa`)
- `tmux.conf` - Tmux config: `C-a` prefix, vim-style pane navigation (hjkl), `\` and `-` for splits
- `gitconfig` - Git user config, LFS filters, aliases (`shove`, `publish`, `a`)
- `setup.bash` - Installation script that creates symlinks and installs vim plugins
