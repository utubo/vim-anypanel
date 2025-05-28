vim9script

export def TabPanel(): string
  const bufs = tabpagebuflist(g:actual_curtabpage)
  var mod = ''
  for bufnr in bufs
    if getbufvar(bufnr, "&modified")
      mod = '+'
      break
    endif
  endfor
  const wincount_num = tabpagewinnr(g:actual_curtabpage, '$')
  const wincount = wincount_num < 2 ? '' : $'{wincount_num}'
  const name = bufs[tabpagewinnr(g:actual_curtabpage) - 1]->bufname()
  const sep = !wincount && !mod ? '' : ' '
  const width = &tabpanelopt
    ->matchstr('\(columns:\)\@<=\d\+') ?? '20'
  return $'{wincount}{mod}{sep}{name ?? '[No Name]'}'
    ->substitute($'\%{width->str2nr()}v.*', '', '')
enddef
