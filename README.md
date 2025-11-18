# vim-anypanel

This is a plugin that helps you customize the tab panel.
![image](https://github.com/user-attachments/assets/ff276d1d-2afc-4367-9be5-3891b43426ea)

## Requirements

Vim 9.1.1900 +tabpanel

## Get start

Place vim-anypanel in `&rtp`.  
Example
```bash
mkdir ~/.vim/pack/foo
cd ~/.vim/pack/foo
git clone https://github.com/utubo/vim-anypanel.git
```

```vim
vim9script

packadd vim-anypanel

g:anypanel_contents = [
  # Top
  # You can set any expr.
  'strftime("%Y-%m-%d")',
  'strftime("  %H:%M")',
  # Tab labels
  # You can set list<string> to show the tab labels.
  ['anypanel#TabBufs()'],
  # Below the tab labels
  'anypanel#HiddenBufs()',
  # Padding
  '%=',
  # Bottom
  'anypanel#Calendar()',
]
anypanel#Init()
set showtabpanel=2

# To update the minutes...
timer_start(60000, (_) => { redrawtabpanel }, { repeat: -1 })
```

## Settings
See [doc/anypanel.txt](doc/anypanel.txt).

## You can add any components
Example
- [autoload/anypanel/tabbufs.vim](autoload/anypanel/tabbufs.vim)
- [autoload/anypanel/calendar.vim](autoload/anypanel/calendar.vim)

