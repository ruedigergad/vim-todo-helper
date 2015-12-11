# vim-todo-helper

vim-todo-helper is intended to aid in working with todo items.

## Overview

vim-todo-helper currently offers the following features:

* Maintain unique ids for todo items.
* Maintain updated modification timestamps for todo items.
* Maintain a list of deleted todo items.
* Provide default values when inserting new todo items in order to speed up the workflow.

## Quick Start

I am using vim-todo-helper in conjunction with [vimoutliner](https://github.com/vimoutliner/vimoutliner).
However, please note that vimoutliner is no mandatory dependency.
Nonetheless, as this is my current setup, I will refer to this setup for the quick start how-to.

### Installation

I suggest to use [pathogen](https://github.com/tpope/vim-pathogen) for installing vim-todo-helper and the other plug-ins.
Please refer to the pathogen documentation for details on installing pathogen.
After installing pathogen, the plug-ins are installed as follows:

    cd ~/.vim/bundle
    git clone git@github.com:ruedigergad/vim-todo-helper.git
    # I primarily use vim-todo-helper with vimoutliner, so install vimoutliner as well:
    git clone git@github.com:vimoutliner/vimoutliner.git

### Configuration

vim-todo-helper uses a different notation for the tags that indicate the importance.
In vim-todo-helper, these tags are prefixed with increasing numbers where the lowest number indicates the highest importance and increasing numbers indicate decreasing importance.
The primary idea of this is to allow meaningful sorting based on the importance by leveraging the lexicographic (alphabetic) sorting of vimoutliner.

In order to adjust these tags accordingly, add the following to your ~/.vimoutlinerrc

    let g:cbTags = [
    \['3_Low','2_Normal','1_High','0_URGENT']
    \]

