vim9script

export def Left(lines: any): any
   const is_str = type(lines) ==# v:t_string
   const src = is_str ? lines->split("\n") : lines
   const width = anypanel#Columns()
   var dest = []
   for s in src
      const t = s->matchstr($'.*\%<{width + 1}v')
      dest->add(t ==# s ? t : $'{t}>')
   endfor
   return is_str ? dest->join("\n") : dest
enddef

export def Right(lines: any): any
   const is_str = type(lines) ==# v:t_string
   const src = is_str ? lines->split("\n") : lines
   const width = anypanel#Columns()
   var dest = []
   for s in src
      if s->strdisplaywidth() <= width
         dest->add(printf($'%{width}S', s))
      else
         const p = (s->strdisplaywidth() - width)
         dest->add(s->substitute($'.*\%{p}v', '<', ''))
      endif
   endfor
   return is_str ? dest->join("\n") : dest
enddef

export def Center(str: string): string
   const width = anypanel#Columns()
   var lines = []
   for s in str->split("\n")
      const p = (s->strdisplaywidth() - width)
      if p <= 0
         lines->add(' '->repeat(-p / 2) .. s)
      else
         lines->add(s
            ->substitute($'.*\%{p / 2}v', '<', '')
            ->substitute($'\%{width}v.*', '>', '')
         )
      endif
   endfor
   return lines->join("\n")
enddef
