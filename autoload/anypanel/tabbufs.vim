vim9script

export def TabPanel(title: string = ''): string
  var lines = []
  for w in gettabinfo(g:actual_curtabpage)[0].windows
    var cur = ' '
    if w ==# win_getid()
      cur = get(g:, 'anypanel_current_symbol', '%%')
    endif
    const b = winbufnr(w)->getbufinfo()[0]
    const mod = !b.changed ? '' : '+'
    const name = b.name->fnamemodify(':t') ?? '[No Name]'
    lines->add($' {cur}{mod}{name}')
  endfor
  return $"{title ?? g:actual_curtabpage}" .. g:anypanel_sep ..
    anypanel#align#Left(lines)->join(g:anypanel_sep)
enddef
