vim9script

var calendar_cache = {
  ymd: '', lines: '', opt: ''
}

export def GetCalendar(_ymd: string = '', _w: number = -1): string
  const ymd = _ymd ?? strftime('%Y-%m-%d')
  if calendar_cache.ymd ==# ymd &&
      calendar_cache.opt ==# &tabpanelopt
    return calendar_cache.lines
  endif
  const [year, month, day] = ymd->split('-')
  const y = year->str2nr()
  const m = month->str2nr()
  const d = day->str2nr()
  var lines = []
  # Month
  # Note: Calender width = 20
  lines->add($'         {month}')
  # Days
  var last_day = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  if y % 4 ==# 0 && y % 100 !=# 0 || y % 400 ==# 0
    last_day[2] = 29
  endif
  var w = _w < 0 ? strftime('%w')->str2nr() : _w
  var wday = (8 + w - d % 7) % 7
  var days = repeat(['  '], wday)
  for i in range(1, last_day[m])
    const dd = printf('%02d', i)
    if dd ==# day
      days->add($'%#TabPanelSel#{dd}%#TabPanel#')
    elseif wday ==# 0
      days->add($'%#AnyPanelCalendarSun#{dd}%#TabPanel#')
    elseif wday ==# 6
      days->add($'%#AnyPanelCalendarSat#{dd}%#TabPanel#')
    else
      days->add(dd)
    endif
    wday = (wday + 1) % 7
    if !wday || i ==# last_day[m]
      lines->add(days->join(' '))
      days = []
    endif
  endfor
  # Centering
  const width = &tabpanelopt
    ->matchstr('\(columns:\)\@<=\d\+') ?? '20'
  const pad_width = width->str2nr() / 2 - 10
  const pad = repeat(' ', pad_width)
  for i in range(0, lines->len() - 1)
    lines[i] = $'%#TabPanel#{pad}{lines[i]}'
  endfor
  # Cache
  calendar_cache.ymd = ymd
  calendar_cache.opt = &tabpanelopt
  calendar_cache.lines = lines->join("\n")
  return calendar_cache.lines
enddef

def SetHighlight()
  hi default link AnyPanelCalendarSun TabPanel
  hi default link AnyPanelCalendarSat TabPanel
enddef

augroup anypanel-calendar
  au! ColorScheme * SetHighlight()
augroup END

SetHighlight()

