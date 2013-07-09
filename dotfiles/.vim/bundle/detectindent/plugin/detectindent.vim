" Name:          detectindent (global plugin)
" Version:       1.0
" Author:        Ciaran McCreesh <ciaran.mccreesh at googlemail.com>
" Updates:       http://github.com/ciaranm/detectindent
" Purpose:       Detect file indent settings
"
" License:       You may redistribute this plugin under the same terms as Vim
"                itself.
"
" Usage:         :DetectIndent
"
"                " to prefer expandtab to noexpandtab when detection is
"                " impossible:
"                :let g:detectindent_preferred_expandtab = 1
"
"                " to set a preferred indent level when detection is
"                " impossible:
"                :let g:detectindent_preferred_indent = 4
"
" Requirements:  Untested on Vim versions below 6.2

if exists("loaded_detectindent")
    finish
endif
let loaded_detectindent = 1

if !exists('g:detectindent_verbosity')
    let g:detectindent_verbosity = 1
endif

fun! <SID>HasCStyleComments()
    return index(["c", "cpp", "java", "javascript", "php"], &ft) != -1
endfun

fun! <SID>IsCommentStart(line)
    " &comments aren't reliable
    return <SID>HasCStyleComments() && a:line =~ '/\*'
endfun

fun! <SID>IsCommentEnd(line)
    return <SID>HasCStyleComments() && a:line =~ '\*/'
endfun

fun! <SID>IsCommentLine(line)
    return <SID>HasCStyleComments() && a:line =~ '^\s\+//'
endfun

fun! <SID>DetectIndent()
    let l:has_leading_tabs            = 0
    let l:tab_count                   = 0
    let l:two_spaces_count            = 0
    let l:analyzed                    = 0
    let l:max_lines                   = 1024

    let l:idx_end = line("$")
    let l:idx = 1
    while l:idx <= l:idx_end
        let l:line = getline(l:idx)

        " try to skip over comment blocks, they can give really screwy indent
        " settings in c/c++ files especially
        if <SID>IsCommentStart(l:line)
            while l:idx <= l:idx_end && ! <SID>IsCommentEnd(l:line)
                let l:idx = l:idx + 1
                let l:line = getline(l:idx)
            endwhile
            let l:idx = l:idx + 1
            continue
        endif

        " Skip comment lines since they are not dependable.
        if <SID>IsCommentLine(l:line)
            let l:idx = l:idx + 1
            continue
        endif

        " Skip lines that are solely whitespace, since they're less likely to
        " be properly constructed.
        if l:line !~ '\S'
            let l:idx = l:idx + 1
            continue
        endif


        let l:leading_char = strpart(l:line, 0, 1)

        if l:leading_char == "\t"
            let l:tab_count = l:tab_count + 1
            let l:analyzed = l:analyzed + 1
        elseif l:leading_char == " "
            " only interested if we don't have a run of spaces followed by a
            " tab.
            if -1 == match(l:line, '^ \+\t')
                let l:spaces = strlen(matchstr(l:line, '^ \+'))
                let l:analyzed = l:analyzed + 1
                if l:spaces == 2
                    let l:two_spaces_count = l:two_spaces_count + 1
                endif
            endif
        endif

        let l:idx = l:idx + 1

        let l:max_lines = l:max_lines - 1

        if l:max_lines == 0
            let l:idx = l:idx_end + 1
        endif

    endwhile

    if l:tab_count*10 > l:analyzed
        setl noexpandtab
        setl ts=4 sts=4 sw=4
    else
        setl expandtab
        if l:two_spaces_count*20 > l:analyzed
            setl ts=2 sts=2 sw=2
        else
            setl ts=4 sts=4 sw=4
        endif
    endif
endfun

command! -bar -nargs=0 DetectIndent call <SID>DetectIndent()

