vim9script

export def TabPanel(): string
	var label = [$'{g:actual_curtabpage}']
	for w in gettabinfo(g:actual_curtabpage)[0].windows
		const cur = w ==# win_getid() ? '>' : ' '
		const b = winbufnr(w)->getbufinfo()[0]
		const mod = !b.changed ? '' : '+'
		const name = b.name->fnamemodify(':t') ?? '[No Name]'
		const width = &tabpanelopt
			->matchstr('\(columns:\)\@<=\d\+') ?? '20'
		label->add($' {cur}{mod}{name}'
			->substitute($'\%{width}v.*', '>', ''))
	endfor
	return label->join("\n")
enddef
