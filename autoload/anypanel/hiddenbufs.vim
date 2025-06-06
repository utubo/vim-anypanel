vim9script

def BufLabel(b: dict<any>): string
  const nr = $'{b.bufnr}:'
  const mod = !b.changed ? '' : '+'
  const name = b.name->fnamemodify(':t') ?? '[No Name]'
  const width = &tabpanelopt
    ->matchstr('\(columns:\)\@<=\d\+') ?? '20'
  return $' {nr}{mod}{name}'
    ->substitute($'\%{width}v.*', '>', '')
enddef

export def TabPanel(): string
  var label = []
  const hiddens = getbufinfo({ buflisted: 1 })
    ->filter((_, v) => v.hidden)
  if !!hiddens
    label->add('%#TabPanel#Hidden')
    for h in hiddens
      label->add($'%#TabPanel#{h->BufLabel()}')
    endfor
  endif
  return label->join("\n")
enddef

augroup anypanel_hiddenbufs
  autocmd BufDelete * autocmd SafeState * ++once redrawtabpanel
augroup END
