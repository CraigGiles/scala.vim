" Plugin Entry Point: ----- !! Side Effects!! {{{
function! scala#package#InsertPackageCmd()
    let a:package = scala#package#InsertPackageStatement(expand('%:p:r'), g:scala_package_flat_package)
    return append(0, a:package)
endfunction
" }}}
" {{{ Composing Function Helpers
function! scala#package#InsertPackageStatement(str, flat_package)
    let l:a = scala#package#AbsolutePathToCodePath(a:str)
    let l:b = scala#package#SlashToDot(l:a)
    let l:c = scala#package#RemoveLastWord(l:b)
    let l:d = scala#package#InsertPackageKeyword(l:c)

    if (a:flat_package == 1)
        return [l:d]
    else
        return scala#package#FlatPackageToMultiplePackage(l:d)
endfunction
" }}}
" {{{ Function Helpers


function! scala#package#AbsolutePathToCodePath(p)
  let l:scala_package_prefix = [ "main", "test", "it" ]
  let l:test = a:p

  for i in l:scala_package_prefix
    let l:test = substitute(l:test, ".*src\/" . i . "\/scala/", "", "")
  endfor

  return l:test
endfunction

function! scala#package#SlashToDot(p)
    return substitute(a:p, "/", ".", "g")
endfunction

function! scala#package#RemoveLastWord(p)
    let l:ary = split(a:p, '\.')
    let l:length = len(l:ary)
    let l:all_but_last = l:ary[0:l:length - 2]

    return join(l:all_but_last, '.')
endfunction

function! scala#package#InsertPackageKeyword(p)
    return "package " . a:p
endfunction

function! scala#package#FlatPackageToMultiplePackage(p)
    let l:removed_package = split(a:p)[1]
    let l:ary = split(l:removed_package, '\.')
    let l:firsttwo = l:ary[0] . "." . l:ary[1]
    let l:next = [l:firsttwo] + l:ary[2:]

    let l:joined = []
    for i in l:next
        let l:joined = l:joined + ["package " . i]
    endfor

    return l:joined
endfunction
" }}}

" vim:set sw=2 sts=2 foldmethod=marker:
