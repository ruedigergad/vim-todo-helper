" todo-helper.vim
" Description: This plug-in provides helper functions for handling todo items.
" Maintainer:  Ruediger Gad <http://ruedigergad.com>
" Version:     0.1
" License:     Eclipse Public License (EPL) version 1.0 or at your option any
"              later version

if exists('s:loaded')
	finish
endif
let s:loaded = 1

let g:todo_item_pattern = '\t<[0-9]*> {.\{19}}$'
let g:id_pattern = '<[0-9]*>'
let g:deleted_ids_list_pattern = '{[0-9,]*}'

function AppendIdAndTimeStamp()
    let b:max_id = b:max_id + 1
    let @x = "\t<" . b:max_id . "> " . strftime("{%Y-%m-%d_%H:%M:%S}")
	normal! $"xp
endfunction

function InsertNewItem(above)
    if a:above
        let l:insert_op = "O"
    else
        let l:insert_op = "o"
    endif

    let l:op_string = "normal! " . l:insert_op . "[_] [3_Low] \<ESC>mx$:call AppendIdAndTimeStamp()\<cr>`x:delmarks x\<cr>a"
    execute l:op_string
endfunction

function! UpdateDate(line)
    let b:changing = 1
    let b:cursor_position = getcurpos()
    if match(getline(a:line), g:todo_item_pattern) > -1
        execute a:line . 's/{.\{19}}$/' . strftime("{%Y-%m-%d_%H:%M:%S}") . "/"
    endif
    call setpos(".", b:cursor_position)
endfunction

function! RestoreCursorPosition()
    let b:changing = 0
    let b:line_changed = 0
    let b:last_change_on = -1
    call setpos(".", b:cursor_position)
endfunction

function! TextChangedCb()
    if !b:changing
        if b:line_count > line("$")
            let l:count = 1
            let l:deleted_item_id_string = matchstr(@", g:id_pattern)

            while l:deleted_item_id_string != ""
                let l:deleted_item_id = str2nr(strpart(l:deleted_item_id_string, 1, strlen(l:deleted_item_id_string) - 2))
                if l:deleted_item_id > 0
                    call add(b:deleted_ids, l:deleted_item_id)
                endif
                let l:count = l:count + 1
                let l:deleted_item_id_string = matchstr(@", g:id_pattern, 0, l:count)
            endwhile

            let b:line_changed = 0
            let b:last_change_on = -1
        else
            if !b:line_changed && search(g:todo_item_pattern, "nc", line("."))
                let b:line_changed = 1
                let b:last_change_on = line(".")
            endif
        endif
    else
        call RestoreCursorPosition()
    endif

    let b:line_count = line("$")
endfunction

function! UpdateDateWhenNeeded(force)
    if !b:changing && b:line_changed && b:last_change_on > -1 && (a:force || b:last_change_on != line("."))
        call UpdateDate(b:last_change_on)
    endif
endfunction

function! DetermineMaxId()
    let l:cur_pos = getcurpos()

    let l:matching_line = search(g:todo_item_pattern, 'W')
    while l:matching_line
        let l:current_id_string = matchstr(getline(l:matching_line), g:id_pattern)
        let l:current_id = str2nr(strpart(l:current_id_string, 1, strlen(l:current_id_string) - 2))

        if l:current_id > b:max_id
            let b:max_id = l:current_id
        endif

        let l:matching_line = search(g:todo_item_pattern, 'W')
    endwhile

    call setpos(".", l:cur_pos)
endfunction

function! ReadMetaData()
    let b:line_count = line("$")

    let l:max_id_string = matchstr(getline("$"), g:id_pattern)

    if l:max_id_string != ""
        let b:max_id = str2nr(strpart(l:max_id_string, 1, strlen(l:max_id_string) - 2))
    else
        call DetermineMaxId()
    endif

    let l:deleted_ids_string = matchstr(getline("$"), g:deleted_ids_list_pattern)

    if l:deleted_ids_string != ""
        let b:deleted_ids = split(strpart(l:deleted_ids_string, 1, strlen(l:deleted_ids_string) - 2), ",")
    endif
endfunction

function! NrCompare(a1, a2)
    return a:a1 - a:a2
endfunction

function! WriteMetaData()
    let b:changing = 1
    let b:cursor_position = getcurpos()

    for l:id in b:deleted_ids
        let l:pos = search("<" . l:id . ">", "nw")
        if l:pos != 0 && l:pos != line("$")
            call remove(b:deleted_ids, index(b:deleted_ids, l:id))
        endif
    endfor
    call sort(b:deleted_ids, "NrCompare")
    call uniq(b:deleted_ids)

    let l:last_line = getline("$")
    if match(l:last_line, g:id_pattern . " " . g:deleted_ids_list_pattern) == -1
        call setpos(".", [0, line("$"), 0, 0])
        execute "normal! o: <" . b:max_id . "> {" . join(b:deleted_ids, ",") . "}"
        call setpos(".", b:cursor_position)
    else
        if match(l:last_line, g:id_pattern) > -1
            execute line("$") . "s/" . g:id_pattern . "/<" . b:max_id . ">/"
        endif

        if match(l:last_line, g:deleted_ids_list_pattern) > -1 && !empty(b:deleted_ids)
            execute line("$") . "s/" . g:deleted_ids_list_pattern . "/{" . join(b:deleted_ids, ",") . "}/"
        endif
    endif
endfunction

function! PreWriteCb()
    call UpdateDateWhenNeeded(1)
    call WriteMetaData()
endfunction

let b:changing = 0
let b:deleted_ids = []
let b:last_change_on = -1
let b:line_count = 0
let b:line_changed = 0
let b:max_id = 0

autocmd BufReadPost *.otl :call ReadMetaData()
autocmd BufWritePre *.otl :call PreWriteCb()
autocmd TextChanged *.otl :call TextChangedCb()
autocmd TextChangedI *.otl :call TextChangedCb()
autocmd CursorMoved *.otl :call UpdateDateWhenNeeded(0)
autocmd CursorMovedI *.otl :call UpdateDateWhenNeeded(0)

noremap <silent><buffer> * :call InsertNewItem(1)<cr>a
noremap <silent><buffer> + :call InsertNewItem(0)<cr>a

