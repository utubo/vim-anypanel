vim9script

var cache = {}

def Load(f: string)
  if filereadable(f)
    cache[f] = readfile(f)[0 : &lines]->join(g:anypanel_sep)
  else
    cache[f] = ''
  endif
enddef

def Reload()
  const f = expand('%')->fnamemodify(':p')
  if cache->has_key(f)
    Load(f)
    redrawtabpanel
  endif
enddef

export def TabPanel(path: string): string
  const f = expand(path)->fnamemodify(':p')
  if cache->has_key(f)
    return cache[f]
  endif
  augroup tabpane_file
    autocmd!
    autocmd BufWritePost,BufReadPost * Reload()
  augroup END
  Load(f)
  return cache[f]
enddef

