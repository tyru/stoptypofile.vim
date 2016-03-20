scriptencoding utf-8

if exists('g:loaded_stoptypofile')
  finish
endif
let g:loaded_stoptypofile = 1

let s:save_cpo = &cpo
set cpo&vim


if !get(g:, 'stoptypofile_no_default_autocmd', 0)

    " For jp106 keyboard: [, ]
    " For us101 keyboard: ], \
    let g:stoptypofile_autocmd_chars =
    \   get(g:, 'stoptypofile_autocmd_chars', '[]\')

    function! s:build_pattern(chars) abort
        let patlist = split(a:chars, '\zs')
        let patlist = map(patlist, 'v:val ==# "\\" ? "[\\\\]" : v:val')
        let patlist = map(patlist, '"*" . v:val')
        return join(patlist, ',')
    endfunction

    augroup stoptypofile
        autocmd!
        " Add two spaces before 'call' because
        " pattern[-1] can be '\'.
        execute 'autocmd BufWriteCmd '
        \     . s:build_pattern(g:stoptypofile_autocmd_chars)
        \     . '  call stoptypofile#check_typo()'
    augroup END

    delfunction s:build_pattern
endif


let &cpo = s:save_cpo
unlet s:save_cpo
" vim:set et:
