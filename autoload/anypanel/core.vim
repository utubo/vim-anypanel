vim9script

const DEFAULT_EXPR = 'anypanel#default#TabPanel()'
var lines_height = {}

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

def GetExpr(index: number, default_expr: list<string> = []): list<string>
  const expr = get(g:, 'anypanel', [])->get(index, [])
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
    if g:actual_curtabpage ==# 1
      lines += GetContents(1, '', [DEFAULT_EXPR])
    endif

    if g:actual_curtabpage !=# tabpagenr('$')
      lines_height[g:actual_curtabpage] = lines->len()
      return lines->join("\n")
    endif

    # Below
    lines += GetContents(2, 'AnyPanelBelow')

    # Padding
    var pad = &lines
    for i in range(1, g:actual_curtabpage - 1)
      pad -= get(lines_height, i, 0)
    endfor
    pad -= lines->len()
    pad -= &cmdheight

    # Bottom
    var bottoms = []
    for expr in GetExpr(3)
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
    g:anypanel_err = $"{v:exception}\n{v:throwpoint}"
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
  set tabpanel=%!anypanel#core#TabPanel()
enddef

