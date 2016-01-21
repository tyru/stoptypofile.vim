scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! stoptypofile#check_typo()
    let file = expand('<afile>')
    let writecmd = 'write' . (v:cmdbang ? '!' : '') . ' ' . file
    if exists('b:stoptypofile_nocheck')
        execute writecmd
        return
    endif
    let prompt = "possible typo: really want to write to '" . file . "'?(y/n):"
    let input = s:ask(prompt)
    if input ==# 'YES'
        execute writecmd
        let b:stoptypofile_nocheck = 1
    elseif input =~? '^y\(es\)\=$'
        execute writecmd
    endif
endfunction

" * inputsave() / inputrestore()
" * highlight support
function! s:ask(...) abort
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
