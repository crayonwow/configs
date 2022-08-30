call plug#begin()
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'AndrewRadev/splitjoin.vim'
"Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'neoclide/coc-json'
Plug 'tpope/vim-fugitive'
Plug 'rking/ag.vim'
Plug 'airblade/vim-gitgutter'
"Plug 'kien/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'bagrat/vim-buffet'
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " need some setup
Plug 'rust-lang/rust.vim'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'lambdalisue/nerdfont.vim'
call plug#end()


""""""""""""""""""""""""""""""""""""""
"""""""""""" TODO LIST """""""""""""""
""""""""""""""""""""""""""""""""""""""
" javascript support

set updatetime=150
set smartcase
set ignorecase
set noswapfile

" line highlight 
set cursorline
" augroup CursorLine
"   au!
"   au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"   au WinLeave * setlocal nocursorline
" augroup END
 
 
 
" copy to buffer
set clipboard=unnamedplus

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
autocmd BufNewFile,BufRead *.htm,*.html setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 

let g:mapleader = ','

let g:go_highlight_types = 0
let g:go_highlight_fields = 0
let g:go_highlight_functions = 0
let g:go_highlight_function_calls = 0
let g:go_highlight_function_parameters = 0
let g:go_highlight_operators = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_build_constraints = 0
let g:go_highlight_variable_declarations = 0
let g:go_highlight_variable_assignments = 0
let g:go_highlight_diagnostic_errors = 1 
let g:go_highlight_diagnostic_warnings = 1
let g:go_mod_fmt_autosave = 1
let g:go_imports_autosave = 1

let g:go_doc_keywordprg_enabled = 0
let g:go_doc_balloon = 1

set foldmethod=indent   
set foldnestmax=10
set nofoldenable
set foldlevel=2
set shortmess+=c

""""""""""""""""""""""""""""""""""""""
"""""""""" VISUAL SETTINGS """""""""""
""""""""""""""""""""""""""""""""""""""
" should be in this speicific order
let g:VM_theme = 'codedark'
syntax on
" transparent backgroung
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
  augroup END
endif
colorscheme onedark
"set t_Co=256
"color summerfruit256


if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
  set termguicolors
endif

 
 
"LINE NUBERS
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


" Add missing imports on save
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

"""""""""""""""""""""""""""""""""""
""""""""""CUSTOM MAPPINGS""""""""""
"""""""""""""""""""""""""""""""""""
" Coc-mappings
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call CocActionAsync('doHover')<cr>
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

"nmap <silent> <C-Y> <Plug>(go-describe)

" coc suggestion navigation
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" use <tab> for trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <C-@> on vim
inoremap <silent><expr> <c-@> coc#refresh()

noremap <silent> <C-[> :call CocAction('diagnosticNext')<CR>

" Use <C-l> for trigger snippet expand.
imap <C-s> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)
let g:UltiSnipsExpandTrigger="<tab>"


" NERDTree-mappings
"nnoremap <C-n> :NERDTreeToggle<CR>
nmap <C-n> <Cmd>CocCommand explorer<CR>

" tab navigation
map <silent> <C-h> :call WinMove('h')<CR>
map <silent> <C-j> :call WinMove('j')<CR>
map <silent> <C-k> :call WinMove('k')<CR>
map <silent> <C-l> :call WinMove('l')<CR>


nmap <leader>1 <Plug>BuffetSwitch(1)
nmap <leader>2 <Plug>BuffetSwitch(2)
nmap <leader>3 <Plug>BuffetSwitch(3)
nmap <leader>4 <Plug>BuffetSwitch(4)
nmap <leader>5 <Plug>BuffetSwitch(5)
nmap <leader>6 <Plug>BuffetSwitch(6)
nmap <leader>7 <Plug>BuffetSwitch(7)
nmap <leader>8 <Plug>BuffetSwitch(8)
nmap <leader>9 <Plug>BuffetSwitch(9)
nmap <leader>0 <Plug>BuffetSwitch(10) 

noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>
noremap <Leader><Tab> :Bw<CR>
noremap <Leader><S-Tab> :Bw!<CR>
noremap <C-t> :tabnew split<CR>

let g:buffet_powerline_separators = 1
let g:buffet_always_show_tabline = 0

" vim-visual-multi mappings
let g:VM_maps = {}
let g:VM_maps['Find Under']         = ''
let g:VM_maps['Find Subword Under'] = ''


cnoremap jk <c-c>
inoremap jk <Esc>

map <Leader> <Plug>(easymotion-prefix)

tnoremap <Esc> <C-\><C-n>

" есть желание реализовать переход на верхнюю/нижнюю строку в режиме вставки
" нужно потрахаться с терминалом тк он детектит нажатия c-enter и s-enter
" inoremap <C-Enter> :OA

" functions 
function! WinMove(key)
	let t:curwin = winnr()
	exec "wincmd ".a:key
	if (t:curwin == winnr())
		if (match(a:key,'[jk]'))
			wincmd v
		else 
			wincmd s
		endif
		exec "wincmd ".a:key
	endif
endfunction

