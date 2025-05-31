vim9script

export def Left(str: string): string
   const width = anypanel#Columns()
   var lines = []
   for s in str->split("\n")
      lines->add(s->substitute($'\%{width}v.*', '>', ''))
   endfor
   return lines->join("\n")

enddef

export def Right(str: string): string
   const width = anypanel#Columns()
   var lines = []
   for s in str->split("\n")
      if s->strdisplaywidth() <= width
         lines->add(printf($'%{width}S', s))
      else
         const p = (s->strdisplaywidth() - width)
         lines->add(s->substitute($'.*\%{p}v', '<', ''))
      endif
   endfor
   return lines->join("\n")
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
