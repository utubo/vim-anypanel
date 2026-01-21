vim9script

def BufLabel(b: dict<any>): string
  const nr = $'{b.bufnr}:'
  const mod = !b.changed ? '' : '+'
  const name = b.name->fnamemodify(':t') ?? '[No Name]'
  const width = &tabpanelopt
    ->matchstr('\(columns:\)\@<=\d\+') ?? '20'
  return $' {nr}{mod}{name}'
enddef

export def TabPanel(): string
  const hiddens = getbufinfo({ buflisted: 1 })
    ->filter((_, v) => v.hidden)
  if !hiddens
    return ''
  endif
  var label = []
  for h in hiddens
    label->add(h->BufLabel())
  endfor
  return "%#TabPanel#Hidden" .. g:anypanel_sep
    .. anypanel#align#Left(label)->join(g:anypanel_sep)
enddef

augroup anypanel_hiddenbufs
  autocmd BufDelete * autocmd SafeState * ++once redrawtabpanel
augroup END
