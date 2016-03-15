scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" For jp106 keyboard: [, ]
" For us101 keyboard: ], \
let g:stoptypofile#check_pattern =
\   get(g:, 'stoptypofile#check_pattern', '[[\]\\]$')
" Some plugins are using special buffer name.
let g:stoptypofile#ignore_pattern =
\   get(g:, 'stoptypofile#ignore_pattern', '^\[qfreplace\]$')

function! stoptypofile#check_typo()
    let file = expand('<afile>')
    let writecmd = 'write' . (v:cmdbang ? '!' : '') . ' ' . file
    if s:is_ignored_file(file)
        execute writecmd
        return
    endif
    if file !~# g:stoptypofile#check_pattern
    \   || file =~# g:stoptypofile#ignore_pattern
        if file !~# g:stoptypofile#check_pattern
            execute writecmd
        endif
        return
    endif
    let prompt = "possible typo: really want to write to '"
    \           . file . "'?(y/n):"
    if s:input(prompt) =~? '^y\(es\)\=$'
        execute writecmd
        call s:add_ignore_file(file)
    endif
endfunction

let s:ignored_files = {}
function! s:is_ignored_file(file) abort
    let file = resolve(fnamemodify(a:file, ':p'))
    return has_key(s:ignored_files, file)
endfunction

function! s:add_ignore_file(file) abort
    let file = resolve(fnamemodify(a:file, ':p'))
    let s:ignored_files[file] = 1
endfunction

" * inputsave() / inputrestore()
" * highlight support
function! s:input(...) abort
    call inputsave()
    echohl WarningMsg
    try
        return call('input', a:000)
    finally
        echohl None
        call inputrestore()
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:set et:
