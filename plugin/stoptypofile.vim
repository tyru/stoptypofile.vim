scriptencoding utf-8

if exists('g:loaded_stoptypofile')
  finish
endif
let g:loaded_stoptypofile = 1

let s:save_cpo = &cpo
set cpo&vim


if !get(g:, 'stoptypofile_no_default_autocmd', 0)
    augroup stoptypofile
        autocmd!
        autocmd BufWriteCmd * call stoptypofile#check_typo()
    augroup END
endif


let &cpo = s:save_cpo
unlet s:save_cpo
" vim:set et:
