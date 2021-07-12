
" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'NLKNguyen/papercolor-theme'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"开/关NERDTree快捷键
map <C-n> :NERDTreeToggle<CR>    
"不显示隐藏文件
let g:NERDTreeHidden=0
"let g:NERDTreeGitStatusUseNerdFonts = 1 
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

" set relativenumber
set nowrap
set noswapfile
set nobackup
set noundofile
set nu
set mouse=a
set clipboard=unnamed   "共享剪贴板(鼠标中键)
syntax on

set background=light
"set background=dark
colorscheme PaperColor

"防止中文乱码
set encoding=UTF-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set fileencoding=utf-8
"防止中文乱码

" colorscheme desert
set guifont=Fira\ Code\ 11 
"set guifont=Monaco\ 10 
set ignorecase
set smartcase
set shiftwidth=4
set expandtab
set softtabstop=4
set showmatch
"set hlsearch
set wildmenu
set wildmode=longest:list,full
set clipboard=unnamed
set autoread
set fileformat=unix
set title

" inoremap ' ''<left>
" inoremap " ""<left>
inoremap [ []<left>
inoremap [[ [
inoremap [] []
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}
inoremap ( ()<left>
inoremap (( (
inoremap () ()
inoremap <C-L> <esc>f)a

" sudo 保存当前窗口内容
cnoremap w!! w !sudo tee "%" > /dev/null

noremap <C-L> <Esc>:tabnext<CR>
noremap <C-H> <Esc>:tabprevious<CR>

set laststatus=2 " 总是显示状态栏
" 语言相关
if $LANGUAGE =~ '^zh' || ($LANGUAGE == '' && v:lang =~ '^zh')
  " 缓冲区号 文件名 行数 修改 帮助 只读 编码 换行符 BOM ======== 字符编码 位置 百分比位置
  set statusline=%n\ %<%f\ %L行\ %{&modified?'[+]':&modifiable\|\|&ft=~'^\\vhelp\|qf$'?'':'[-]'}%h%r%{&fenc=='utf-8'\|\|&fenc==''?'':'['.&fenc.']'}%{&ff=='unix'?'':'['.&ff.']'}%{&bomb?'[BOM]':''}%{&eol?'':'[noeol]'}%{&diff?'[diff]':''}%=\ 0x%-4.8B\ \ \ \ %-14.(%l,%c%V%)\ %P
else
  set statusline=%n\ %<%f\ %LL\ %{&modified?'[+]':&modifiable\|\|&ft=~'^\\vhelp\|qf$'?'':'[-]'}%h%r%{&fenc=='utf-8'\|\|&fenc==''?'':'['.&fenc.']'}%{&ff=='unix'?'':'['.&ff.']'}%{&bomb?'[BOM]':''}%{&eol?'':'[noeol]'}%{&diff?'[diff]':''}%=\ 0x%-4.8B\ \ \ \ %-14.(%l,%c%V%)\ %P
endif

map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
        exec "w"
        if &filetype == 'c'
                exec "!gcc % -o %<"
                exec "! ./%<"
        elseif &filetype == 'sh'
                exec "!bash %"
        elseif &filetype == 'cpp'
                exec "!g++ % -o %<"
                exec "!time ./%<"
        elseif &filetype == 'java'
                exec "!javac %"
                exec "!time java %<"
        elseif &filetype == 'python'
                exec "!time python %"
        elseif &filetype == 'html'
                exec "!google-chrome-stable % &"
        elseif &filetype == 'go'
                " exec "!go build %<"
                exec "!time go run %"
        elseif &filetype == 'mkd'
                exec "!~/.vim/markdown.pl % > %.html &"
                exec "!google-chrome-stable %.html &"
        endif
endfunc



"==========================================================================
"新建 shell 脚本文件时，自动添加文件头
"==========================================================================
function HeaderShell()
    call setline(1, "#!/bin/bash")
"    call append(1, "# Author: 5up3r <i@5up3r.me>")
"    call append(1, "# CreateTime: " . strftime('%Y-%m-%d %T', localtime()))
    normal G
    normal o
    normal o
endf

autocmd bufnewfile *.sh call HeaderShell()


"==========================================================================
" 新建 Python 文件时，自动添加文件头
"==========================================================================
function HeaderPython()
    call setline(1, "#!/usr/bin/env python")
"    call append(1, "# -*- coding: utf-8 -*-")
"    call append(1, "# Author: 5up3r <i@5up3r.me>")
"    call append(1, "# CreateTime: " . strftime('%Y-%m-%d %T', localtime()))
    normal G
    normal o
    normal o
endf

autocmd bufnewfile *.py,*.pyx call HeaderPython()
