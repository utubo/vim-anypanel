vim9script

def Edit(lines: any, F: func): any
   const is_str = type(lines) ==# v:t_string
   const src = is_str ? lines->split("\n") : lines
   const width = anypanel#Columns()
   var dest = []
   for s in src
      dest->add(F(s, width))
   endfor
   return is_str ? dest->join(g:anypanel_sep) : dest
enddef

export def Left(lines: any): any
   return Edit(lines, (s, width) => {
      const t = s->matchstr($'.*\%<{width + 1}v')
      return t ==# s ? t : $'{t}>'
   })
enddef

export def Right(lines: any): any
   return Edit(lines, (s, width) => {
      if s->strdisplaywidth() <= width
         return printf($'%{width}S', s)
      else
         const p = (s->strdisplaywidth() - width)
         return s->substitute($'.*\%{p}v', '<', '')
      endif
   })
enddef

export def Center(lines: string): string
   return Edit(lines, (s, width) => {
      const p = (s->strdisplaywidth() - width)
      if p <= 0
         return ' '->repeat(-p / 2) .. s
      else
         return s
           ->substitute($'.*\%{p / 2}v', '<', '')
           ->substitute($'\%{width}v.*', '>', '')
      endif
   })
enddef
