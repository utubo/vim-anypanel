vim9script

const DEFAULT_EXPR = 'anypanel#TabBufs()'
const MAX_ERR_LINES = 1000

const INDEX_TOP = 0
const INDEX_TABS = 1
const INDEX_BELOW = 2
const INDEX_BOTTOM = 3

g:anypanel_err = []
var lines_height = {}
var settings = []
var legacy = false
var index_tabs = -1
var index_pq = -1
var has_tabs = false
var has_pq = false

def Hi(lines: list<string>, hiname: string): list<string>
  if !hiname
    return lines
  endif
  var h = []
  for line in lines
    h->add($'%#{hiname}#{line}')
  endfor
  return h
enddef

def ResolveSettings()
  settings = get(g:, 'anypanel_panels', [])
  legacy = !settings
  if legacy
    settings = get(g:, 'anypanel', [])
  else
    index_tabs = settings->indexof((_, v) => type(v) ==# v:t_list)
    index_pq = settings->indexof((_, v) => type(v) ==# v:t_string && v ==# '%=')
    has_tabs = index_tabs !=# -1
    has_pq = index_pq !=# -1
  endif
enddef

def ParseSettings(index: number): list<string>
  if legacy
    return settings->get(index, [])
  elseif index ==# INDEX_TABS && has_tabs
    return settings[index_tabs]
  elseif index ==# INDEX_TOP && 0 < index_tabs
    return settings[0 : index_tabs - 1]
  elseif index ==# INDEX_BELOW && has_tabs
    if has_pq
      return settings[index_tabs + 1 : index_pq - 1]
    else
      return settings[index_tabs + 1 :]
    endif
  elseif index ==# INDEX_BOTTOM && has_pq
    return settings[index_pq + 1 : ]
  else
    return []
  endif
enddef

def GetExpr(index: number, default_expr: list<string> = []): list<string>
  const expr = ParseSettings(index)
  if type(expr) ==# v:t_string
    return !expr ? default_expr : [expr]
  else
    return expr->empty() ? default_expr : expr
  endif
enddef

def GetContents(
    index: number,
    hiname: string,
    default_expr: list<string> = []
): list<string>
  var lines = []
  for expr in GetExpr(index, default_expr)
    lines += execute($'echon {expr}')
      ->split("\n")
      ->Hi(hiname)
  endfor
  return lines
enddef

export def TabPanel(): string
  try
    var lines = []

    # Top
    if g:actual_curtabpage ==# 1
      lines += GetContents(0, 'AnyPanelTop')
    endif

    # Tab
    lines += GetContents(1, '', [DEFAULT_EXPR])

    if g:actual_curtabpage !=# tabpagenr('$')
      lines_height[g:actual_curtabpage] = lines->len()
      return lines->join("\n")
    endif

    # Below
    lines += GetContents(2, 'AnyPanelBelow')
    lines_height[g:actual_curtabpage] = lines->len()

    # Padding
    var pad = &lines
    for i in range(1, g:actual_curtabpage)
      pad -= get(lines_height, i, 0)
    endfor

    # Bottom
    var bottoms = []
    for expr in GetExpr(INDEX_BOTTOM)
      var bottom = execute($'echon {expr}')->split("\n")
      if pad - bottom->len() < 0
        break
      endif
      pad -= bottom->len()
      bottoms += bottom->Hi('AnyPanelBottom')
    endfor
    lines += repeat(['%#AnyPanelFill#'], pad)
    lines += bottoms

    return lines->join("\n")
  catch
    g:anypanel_err += [$"{v:exception}\n{v:throwpoint}"]
    if MAX_ERR_LINES < g:anypanel_err->len()
      g:anypanel_err = g:anypanel_err[- MAX_ERR_LINES]
    endif
    return '!see g:anypanel_err'
  endtry
enddef

def SetHilight()
  silent hi default link AnyPanelTop TabPanel
  silent hi default link AnyPanelBelow TabPanel
  silent hi default link AnyPanelBottom TabPanel
  silent hi default link AnyPanelFill TabPanelFill
enddef

export def Init()
  augroup anypanel
    autocmd!
    autocmd ColorScheme * SetHilight()
  augroup END
  SetHilight()
  ResolveSettings()
  set tabpanel=%!anypanel#core#TabPanel()
enddef

