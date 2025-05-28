vim9script

var fullpath = ''
var lines = ''

def Load()
  if filereadable(fullpath)
    lines = readfile(fullpath)[0 : &lines]->join("\n")
  else
    lines = ''
  endif
enddef

def Reload()
  if fullpath ==# expand('%')->fnamemodify(':p')
    Load()
    redrawtabpanel
  endif
enddef

export def TabPanel(path: string): string
  const f = expand(path)->fnamemodify(':p')
  if fullpath ==# f
    return lines
  endif
  fullpath = f
  augroup tabpane_file
    autocmd!
    autocmd BufWritePost,BufReadPost * Reload()
  augroup END
  Load()
  return lines
enddef

