set nocompatible
filetype off
call plug#begin('~/.vim/plugged')
command! -nargs=0 Prettier :CocCommand prettier.formatFile
Plug 'neoclide/coc.nvim', {'branch': 'release'}
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<tab>'
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree'
"Plug 'tomtom/tlib_vim'
"Plug 'MarcWeber/vim-addon-mw-utils'
"Plug 'garbas/vim-snipmate'
"Plug 'honza/vim-snippets'
"Plug 'othree/html5.vim'
"Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
"let g:airline#extensions#tabline#enabled = 1
Plug 'vim-airline/vim-airline-themes'
Plug 'elixir-editors/vim-elixir'
Plug 'mhinz/vim-mix-format'
Plug 'fatih/vim-go'
"let g:go_fmt_fail_silently = 1
let g:mix_format_on_save = 1
Plug 'Xuyuanp/nerdtree-git-plugin'
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
call plug#end()
filetype plugin indent on
colorscheme desert
"set statusline^=%{coc#status()}
set noerrorbells
set number
set nobackup
set noswapfile
set wildmenu
set autowrite
set smartcase
set scrolloff=3
set backspace=2
set expandtab
set shiftwidth=2
set cursorline
set softtabstop=2
set tabstop=2
set shortmess=atI
"aTIO
:nmap <space>e :NERDTreeToggle<CR>
"map <C-l> :NERDTreeToggle<CR>
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { {}<ESC>i
inoremap ' ''<ESC>i
inoremap " ""<ESC>i

"inoremap < <><ESC>i
