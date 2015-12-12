# vim-todo-helper

vim-todo-helper is intended to aid in working with todo items.

## Overview

vim-todo-helper currently offers the following features:

* Maintain unique ids for todo items.
* Maintain updated modification timestamps for todo items.
* Maintain a list of deleted todo items.
* Provide default values when inserting new todo items in order to speed up the workflow.

### Usage Example

In order to get a better idea of what vim-todo-helper actually does, a brief example of a possible usage scenario is given below:

Assume you are starting to edit a new file to organize your todos.

    gvim todo.otl &

Starting with the empty file, you can insert a new todo item below the current line by pressing "+".
Alternatively, you can use "*" to insert a new todo above the current line.
A possible result is shown below.
The "X" marks the spot at which the cursor will be placed.

    [_] [3_Low] X	<1> {2015-12-12_13:45:57}

You can see that the new entry has an unchecked check box "[_]", a default priority of "3_Low", an id of 1, and the date shows the date and time when the entry was created.
In a normal workflow, you would now fill in some descriptive text to describe the new task/todo.

The next example shows a few more sample entries:

    [_] [3_Low] A low priority todo	<1> {2015-12-12_13:48:03}
    [_] [3_Low] Another low prioroty todo	<2> {2015-12-12_13:48:12}
    [_] [2_Normal] A higher priority todo	<3> {2015-12-12_13:48:26}
    [_] [0_URGENT] An urgent task	<4> {2015-12-12_13:48:40}

Side note: I use the setting "noremap <silent><buffer> t :call SetNextTag()<cr>" in my ~/.vimoutlinerrc to use "t" for cycling through the different priority levels when the cursor is placed on the priority entry.

The next example shows that the timestamps are updated whenever an item is changed:

    [X] [3_Low] A low priority todo (This was marked as done.)	<1> {2015-12-12_13:50:03}
    [_] [3_Low] Another low priority todo (Fixed a typo here.)	<2> {2015-12-12_13:51:18}
    [_] [1_High] Change importance.	<3> {2015-12-12_13:51:30}
    [_] [0_URGENT] An urgent task	<4> {2015-12-12_13:48:40}

When you write the file, a line will be added to the end of the file that contains some housekeeping meta data.
The data in this line currently shows the highest used id and a list of deleted items.
This data is intended for later use when synchronizing files between multiple computers/devices.
An example of how this looks is shown below:

    [X] [3_Low] A low priority todo	<1> {2015-12-12_13:50:03}
    [_] [3_Low] Another low priority todo (Fixed a typo here.)	<2> {2015-12-12_13:51:18}
    [_] [1_High] Change importance.	<3> {2015-12-12_13:51:30}
    [_] [0_URGENT] An urgent task	<4> {2015-12-12_13:48:40}
    : <4> {}

Please note that this metadata has to be in the very last line of the file, right now.

Last but not least, an example is given how the content looks after deleting some entries:

    [X] [3_Low] A low priority todo	<1> {2015-12-12_13:53:49}
    [_] [0_URGENT] An urgent task	<4> {2015-12-12_13:48:40}
    : <4> {2,3}

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

