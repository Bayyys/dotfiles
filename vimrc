" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Turn on syntax highlighting.
" 显示高亮
syntax on

" Disable the default Vim startup message.
" 隐藏vim默认启动信息
set shortmess+=I

" Show line numbers.
" 显示行号
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
" 显式相对行号
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
" 总是显示窗口的编辑模式
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
" backspace键能删除自动缩进的空格、在一行删除完后合并到上一行、可以删除此次进入插入模式前的输入。
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
" 防止忘记保存。
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
" 搜索命令不区分大小写。
set ignorecase
" 在 set ignorecase 情况下使用，如果搜索模式中出现了大写字符，smartcase会判断用户想使用区分大小写的搜索。
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
" 在输入时启用搜索，而不是等到按回车键。
set incsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
" 禁用出错时的响铃。
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
" 鼠标有效。
set mouse+=a

" 高亮光标所在行。
set cursorline

" 显式括号匹配。
set showmatch

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
set backspace=2
" inoremap <C-j> <Left>
inoremap <C-l> <Right>
" inoremap <C-i> <Up>
" inoremap <C-k> <Down>
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" 映射全选+复制 Ctrl+a
map <C-A> ggVGY
map! <C-a> <Esc>ggVGT

" F2快速打开(或关闭)显示行号。
nnoremap <F2> :set nu! nu?<CR>

" 正常模式：行首、行尾光标移动按键
nnoremap H ^
nnoremap L $

" NERDTree
map <F3> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

set runtimepath^=~/.vim/plugged/ctrlp.vim

" Ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" vim-airline
set laststatus=2  "永远显示状态栏
let g:airline_powerline_fonts = 1  " 支持 powerline 字体
let g:airline#extensions#tabline#enabled = 1 " 显示窗口tab和buffer
" let g:airline_theme='moloai'  " murmur配色不错

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '❯'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '❮'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'

" NerdCommenter
" 代码注释
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' }} 

"Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" Vim-Plug
call plug#begin('~/.vim/plugged') 
Plug 'git@github.com:preservim/nerdtree.git'
" Plug 'git://github.com/mileszs/ack.vim'
Plug 'git@github.com:ctrlpvim/ctrlp.vim.git'
" Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdcommenter'
Plug 'Valloric/YouCompleteMe'
Plug 'dense-analysis/ale'
call plug#end()
