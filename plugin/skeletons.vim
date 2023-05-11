if !exists('g:skeletons_dir')
    let g:skeletons_dir = expand('<sfile>:p:h:h') . '/skeletons/'
endif

function! Skeleton()
    let filetype = &filetype
    let filename = expand("%")
    let skeletonPathFiletype = s:getSkeletonPath(filetype)
    let skeletonPathFilename = s:getSkeletonPath(filename)

    " don't insert skeletons into fugitive's diff windows
    if stridx(filename, 'fugitive:///') >= 0
        return
    endif

    if filereadable(skeletonPathFilename)
       call feedkeys("i\<C-R>=SkeletonExpand('" . filename . "')\<CR>")
    elseif filereadable(skeletonPathFiletype)
       call feedkeys("i\<C-R>=SkeletonExpand('" . filetype . "')\<CR>")
    endif
endfunction!

command! -bar
    \ Skeleton
    \ call Skeleton()

function! SkeletonExpand(filetype)
    let skeleton = s:getSkeleton(a:filetype)
    return UltiSnips#Anon(skeleton)
endfunction!

function! s:getSkeletonPath(skeletonName)
    return g:skeletons_dir . a:skeletonName . '.skeleton'
endfunction!

function! s:getSkeleton(skeletonName)
    return join(readfile(s:getSkeletonPath(a:skeletonName)), "\n")
endfunction!

function! SetSkeletonFiletype()
    let filename = expand("%")
    let splitted = split(filename, "\\.")

    if len(splitted) >= 2
        let filetype = splitted[len(splitted) - 2]
        exec "set ft=" . filetype
    endif
endfunction!

command! -bar
    \ SetSkeletonFiletype
    \ call SetSkeletonFiletype()

augroup vim_ski
    au!
    au BufNewFile * Skeleton

    " broken for skeletons with only filetype + .skeleton as a name
    "   shows errors if you open 'go.skeleton'
    "   no error for 'main.go.skeleton'
    " au BufNewFile,BufRead *.skeleton SetSkeletonFiletype
augroup end
