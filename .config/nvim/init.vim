call plug#begin("~/.vim/plugged")

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gD <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  Plug 'dracula/vim'
  Plug 'kaicataldo/material.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  let g:airline#extensions#tabline#buffer_nr_show = 1
  let g:airline_powerline_fonts = 1
  set t_Co=256
  Plug 'scrooloose/nerdtree'
  let g:NERDTreeShowHidden = 1
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeIgnore = []
  let g:NERDTreeStatusline = ''
  " Automaticaly close nvim if NERDTree is only thing left open
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  " Toggle
  nnoremap <silent> <C-b> :NERDTreeToggle<CR>

  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

  " Plug 'davidhalter/jedi-vim'
  Plug 'ryanoasis/vim-devicons'
  " Latex support
  Plug 'lervag/vimtex'
  let g:tex_flavor='latex'
  let g:vimtex_view_method='zathura'
  let g:vimtex_quickfix_mode=0
  set conceallevel=1
  let g:tex_conceal='abdmg'
  let g:vimtex_compiler_latexmk = {
      \ 'build_dir' : 'output',
  \}

  Plug 'KeitaNakamura/tex-conceal.vim'
  set conceallevel=1
  let g:tex_conceal='abdmg'
  hi Conceal ctermbg=none

  " Pandoc Markdown support
  Plug 'vim-pandoc/vim-pandoc'
  Plug 'vim-pandoc/vim-pandoc-syntax'

  " Snippets
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'

  " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
  let g:UltiSnipsExpandTrigger = '<tab>'
  let g:UltiSnipsJumpForwardTrigger = '<tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

  " If you want :UltiSnipsEdit to split your window.
  let g:UltiSnipsEditSplit="vertical"

  " ALE
  Plug 'dense-analysis/ale'

  " Tree File View
  Plug 'scrooloose/nerdtree'
  let NERDTreeIgnore = ['\.pyc$', '\.class$', 'Test\.java']

  " Themes
  Plug 'mhartington/oceanic-next'
  Plug 'Rigellute/shades-of-purple.vim'

  " Fuzzy Search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  " FZF key bindings
  nnoremap <C-f> :FZF<CR>
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-i': 'split',
    \ 'ctrl-v': 'vsplit' }

  " for writing, to toggle, type :Goyo
  Plug 'junegunn/goyo.vim'

  " Git support
  Plug 'tpope/vim-fugitive'

  Plug 'dylanaraps/wal'

  " if has('nvim')
  "   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " else
  "   Plug 'Shougo/deoplete.nvim'
  "   Plug 'roxma/nvim-yarp'
  "   Plug 'roxma/vim-hug-neovim-rpc'
  " endif
  " let g:deoplete#enable_at_startup = 1
call plug#end()

" open new split panes to right and below
set splitright splitbelow
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" open terminal on ctrl+n
function! OpenTerminal()
  split term://bash
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>
" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" Automatically update on change
" autocmd TextChanged,TextChangedI <buffer> silent update

" Spell check
set spelllang=en_us
" Automatically enable spell check in the given file types
autocmd FileType latex,tex,md,markdown setlocal spell
" Automatically compile markdown files
autocmd BufWritePost *.md silent execute "!pandoc % -o %:r.pdf"
command PandocPDF silent execute "!pandoc % -o %:r.pdf"
map <F6> :PandocPDF<CR>
" For opening markdown files in zathura
command Zathura execute "!zathura %:r.pdf&"
map <F5> :Zathura<CR>

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Enable syntax highlighting
syntax on
" Style preferences
set modeline
" Use spaces instead of tabs
set expandtab
" Be smart when using tabs ;)
set smarttab
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
" 1 tab == 4 spaces
set tabstop=4
set shiftwidth=4
" Linebreak on 500 characters
set lbr
set tw=500
set exrc " .vimrc in local project dir
set secure
autocmd BufRead,BufNewFile * set signcolumn=yes
autocmd FileType tagbar,nerdtree set signcolumn=no
set foldmethod=indent
set nofoldenable
set number relativenumber
set diffopt+=vertical
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
:augroup END

"-- TRUE COLOR --
" For Neovim 0.1.3 and 0.1.4 - https://github.com/neovim/neovim/pull/2198
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

"-- THEMING --
set cursorline
set background=dark

let g:airline_theme='material'
let g:material_theme_style = 'darker'
colorscheme material
hi Normal       ctermbg=NONE guibg=NONE
hi Visual       ctermbg=Green guibg=None
hi SignColumn   ctermbg=235 guibg=#262626
hi LineNr       ctermfg=grey guifg=grey ctermbg=NONE guibg=NONE
hi CursorLineNr ctermbg=NONE guibg=NONE ctermfg=178 guifg=#d7af00

let g:gitgutter_set_sign_backgrounds = 0

"-- Whitespace highlight --
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"-- ALE --
hi clear ALEErrorSign
hi clear ALEWarningSign
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
hi Error    ctermfg=204 ctermbg=NONE guifg=#ff5f87 guibg=NONE
hi Warning  ctermfg=178 ctermbg=NONE guifg=#D7AF00 guibg=NONE
hi ALEError ctermfg=204 guifg=#ff5f87 ctermbg=52 guibg=#5f0000 cterm=undercurl gui=undercurl
hi link ALEErrorSign    Error
hi link ALEWarningSign  Warning

let g:ale_linters = {
            \ 'python': ['pylint'],
            \ 'javascript': ['eslint'],
            \ 'go': ['gobuild', 'gofmt'],
            \ 'rust': ['rls']
            \}
let g:ale_fixers = {
            \ '*': ['remove_trailing_lines', 'trim_whitespace'],
            \ 'python': ['autopep8'],
            \ 'javascript': ['eslint'],
            \ 'go': ['gofmt', 'goimports'],
            \ 'rust': ['rustfmt']
            \}
let g:ale_fix_on_save = 1

"-- NERDTree --
let NERDTreeShowHidden=1

"-- Airline --
let g:airline#extensions#tabline#enabled = 1

"-- Exuberant Ctags --
set tags=tags

"-- NVIM configuration --
" if has('nvim')
"     " Enable deoplete when InsertEnter.
"     let g:deoplete#enable_at_startup = 0
"     autocmd InsertEnter * call deoplete#enable()"

"     set belloff=""
"     call deoplete#custom#source('_',  'max_menu_width', 0)
"     call deoplete#custom#source('_',  'max_abbr_width', 0)
"     call deoplete#custom#source('_',  'max_kind_width', 0)"

"     set hidden
"     let g:LanguageClient_serverCommands = {
"         \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"         \ 'go': ['~/.go/bin/gopls']
"         \ }
" endif


let g:UltiSnipsSnippetDirectories=["UltiSnips", "my_snippets"]

command! -bang GFiles call fzf#vim#gitfiles('', fzf#vim#with_preview('right'))
command! -bang Files call fzf#vim#files('', fzf#vim#with_preview('right'))
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--color-path "1;36"', fzf#vim#with_preview(), <bang>0)
" <ESC> is required to get back to normal mode
inoremap <Leader>s <ESC>:Snippets<CR>i
inoremap jj <Esc>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" To use fzf in Vim, add the following line to your .vimrc:
set rtp+='/usr/local/opt/fzf'
