vim9script

export def TabPanel(title: string = ''): string
  var lines = [title ?? $'{g:actual_curtabpage}']
  for w in gettabinfo(g:actual_curtabpage)[0].windows
    var cur = ' '
    if w ==# win_getid()
      cur = get(g:, 'anypanel_current_symbol', '%')
        ->substitute('%', '%%', 'g')
    endif
    const b = winbufnr(w)->getbufinfo()[0]
    const mod = !b.changed ? '' : '+'
    const name = b.name->fnamemodify(':t') ?? '[No Name]'
    const width = &tabpanelopt
      ->matchstr('\(columns:\)\@<=\d\+') ?? '20'
    lines->add($' {cur}{mod}{name}'
      ->substitute($'\%{width}v.*', '>', ''))
  endfor
  return lines->join("\n")
enddef
