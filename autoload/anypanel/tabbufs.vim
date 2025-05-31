vim9script

export def TabPanel(title: string = ''): string
  var lines = [title ?? $'{g:actual_curtabpage}']
  for w in gettabinfo(g:actual_curtabpage)[0].windows
    const cur = w ==# win_getid() ? '>' : ' '
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
