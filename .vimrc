" vimrc in project root
" loaded by https://github.com/MarcWeber/vim-addon-local-vimrc

set tags=tags;/

set makeprg=gradlew\ --no-color

let s:script_path = expand('<sfile>:p:h') . "/" 


let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|build$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp$',
  \ 'file': '\.exe$\|\.so$\|\.dat$'
  \ }
let g:fuf_dir_exclude='\v(^|[/\\])(\.hg|\.git|\.bzr|build)($|[/\\])'
let g:fuf_file_exclude='\v(^|[/\\])(\.hg|\.git|\.bzr|build)($|[/\\])'

nnoremap <leader>f :CtrlP<CR>

function! ExecuteInProjectRoot(cmdline)
     execute ":cd ".s:script_path
     execute ":AsyncShell ".a:cmdline
endfunction

function! MakeInProjectRoot(cmdline)
     execute ":cd ".s:script_path
     execute ":AsyncMake ".a:cmdline
endfunction

function! AndroidMonitor()
    let l:filename = s:script_path."local.properties"
    execute "vimgrep /\\v^sdk\\.dir=(.*)\s*$/j ".l:filename
    for i in getqflist()
        echom "found ". i.text
        let l:cmd = split(i.text,"=")[1]
        execute ":AsyncCommand " . l:cmd . "\\tools\\monitor.bat"
        break
    endfor
endfunction

command! -nargs=1 ExecuteInProjectRoot :call ExecuteInProjectRoot(<f-args>)
command! InstallFreeRelease :call MakeInProjectRoot("installFreeRelease")
command! UpdateCTags :call ExecuteInProjectRoot("ctags")
command! AndroidMonitor :call AndroidMonitor()