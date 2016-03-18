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
    " Skip if a file is marked as temporarily ignored.
    let file = expand('<afile>')
    let writecmd = 'write' . (v:cmdbang ? '!' : '') . ' ' . file
    if s:is_ignored_file(file)
        return s:do_write(writecmd)
    endif
    " Skip a normal file or ignored file.
    if file !~# g:stoptypofile#check_pattern
    \   || file =~# g:stoptypofile#ignore_pattern
        if file !~# g:stoptypofile#check_pattern
            call s:do_write(writecmd)
        endif
        return
    endif
    " Ask and add to temporarily ignored files
    " if a user input was 'yes'.
    let prompt = "possible typo: really want to write to '"
    \           . file . "'?(y/n):"
    if s:input(prompt) =~? '^y\(es\)\=$'
        call s:do_write(writecmd)
        call s:add_ignore_file(file)
    endif
endfunction

function! s:do_write(writecmd) abort
    execute a:writecmd
    setlocal nomodified
endfunction

let s:ignored_files = {}
" Returns non-zero if a file is temporarily ignored.
function! s:is_ignored_file(file) abort
    let file = resolve(fnamemodify(a:file, ':p'))
    return has_key(s:ignored_files, file)
endfunction

" Mark a file as a temporarily ignored file.
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
