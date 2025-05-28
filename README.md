# vim-anypanel

This is a plugin that helps you customize the tab panel.

## Requirements

Vim 9.1 and +tabpanel

## Get start

Place vim-anypanel in `&rtp`.  
Example
```vim
vim9script

dein#add('utubo/vim-anypanel')
let g:anypanel=[
  # top
  'strftime("  %Y-%m-%d %H:%M  ")',
  # tab labels are default
  '',
  # below the list
  'anypanel#HiddenBufs()',
  # bottom
  [
    'anypanel#Padding(1)',
    'anypanel#Calendar()',
  ],
]
anypanel#Init()

# To update the minutes...
timer_start(60000, (_) => { redrawtabpanel }, { repeat: -1 })
```

## Settings
See [doc/anypanel.txt](doc/anypanel.txt).

## Components
Example
[autoload/anypanel/calendar.vim](autoload/anypanel/calendar.vim)

