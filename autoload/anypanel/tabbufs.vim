vim9script

import './util.vim' as U
import './align.vim' as A

export def TabPanel(title: string = ''): string
  var lines = [$'{title ?? g:actual_curtabpage}']
  for w in gettabinfo(g:actual_curtabpage)[0].windows
    var cur = ' '
    if w ==# win_getid()
      cur = get(g:, 'anypanel_current_symbol', '%')
    endif
    const b = winbufnr(w)->getbufinfo()[0]
    const mod = !b.changed ? '' : '+'
    const name = b.name->fnamemodify(':t') ?? '[No Name]'
    lines->add($"{A.Left($' {cur}{mod}{name}')}"->substitute('%', '%%', 'g'))
  endfor
  return U.Join(lines)
enddef
