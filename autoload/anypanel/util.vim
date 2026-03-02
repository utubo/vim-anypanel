vim9script

const BR = v:versionlong < 9020083 ? "\n" : '%@'
const SP = v:versionlong < 9020083 ? '\n' : '%@\|\n'

export def Join(lines: list<string>): string
   return lines->join(BR)
enddef

export def Split(str: string): list<string>
   return str->split(SP)
enddef
