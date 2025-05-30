vim9script

export def Init(options: any = {})
  if !options->empty()
    g:anypanel = options
  endif
  anypanel#core#Init()
  redrawtabpanel
enddef


export def Columns(): number
  const c = &tabpanelopt
    ->matchstr('\(columns:\)\@<=\d\+') ?? '20'
  return c->str2nr()
enddef

export def Padding(height: number = 1): string
  return repeat(['%#AnyPanelFill#'], height)->join("\n")
enddef

export def SingleLine(): string
  return anypanel#singleLine#TabPanel()
enddef

export def TabBufs(): string
  return anypanel#tabbufs#TabPanel()
enddef

export def Calendar(): string
  return anypanel#calendar#GetCalendar()
enddef

export def HiddenBufs(): string
  return anypanel#hiddenbufs#TabPanel()
enddef

export def File(path: string = '%'): string
  return anypanel#file#TabPanel(path)
enddef

