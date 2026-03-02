vim9script

import './util.vim' as U

var cache = {}

def Load(f: string)
  if filereadable(f)
    cache[f] = U.Join(readfile(f)[0 : &lines])
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

