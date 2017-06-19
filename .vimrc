set nocompatible
" {{{1 Plugin management
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'jalvesaq/Nvim-R' " Successor of R-vimplugin. Requires tmux.
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'vim-scripts/textutil.vim'
Plugin 'chrisbra/csv.vim'
Plugin 'sjl/gundo.vim'
Plugin 'godlygeek/tabular'
Plugin 'lervag/vimtex'
Plugin 'vim-scripts/directionalWindowResizer'
Plugin 'vim-scripts/LanguageTool'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" {{{1 General stuff

" Load US-alt-latin keymap extension
set keymap=us-altlatin

" No wraparournd end of file in normal searches
set nowrapscan
" No high-light search hits
set nohlsearch 
"Search while typing
set incsearch
" Ignore case when searching
set ignorecase
" Case-sensitive when upper case is used in search string
set smartcase

" Use TAB for completions
inoremap <Tab> <c-n>
inoremap <S-Tab> <c-x><c-l>

" Show command completion alternatives
set wildmenu

" Set to auto read when a file is changed from the outside
set autoread

" Foldmethod for .vimrc
autocmd BufRead ~/.vimrc setlocal fdm=marker 

" Set wd for current file
autocmd BufEnter * silent! lcd %:p:h

filetype plugin on
filetype indent on

" Soft-wrap on words
set linebreak

set autoindent

" tab key inserts spaces
set expandtab
"
" Length of tab-character for indention
" 4 spaces for markdown syntax
set shiftwidth=4

set formatoptions=rj
" r    Automatically insert the current comment leader after hitting <Enter> in Insert mode.
" j    Where it makes sense, remove a comment leader when joining lines.

" Enable ALT-key in vim. (Only on Mac)
if has('macunix')
    set macmeta
endif

" Representation of invisible characters with set list
set listchars=tab:▸\ ,eol:¬

" Move to previous buffer
nnoremap ## :b#<CR>

" Open vsplit window to the right
set splitright

" No swapfile exists warning
set shortmess+=A

" Regard markdown extension variants as pandoc
autocmd Filetype mkd set ft=pandoc
autocmd Filetype md  set ft=pandoc
autocmd Filetype markdown  set ft=pandoc

" Vim Pandoc. Add .bib to completion
 let g:pandoc#biblio#bibs = ['/Users/xhalaa/mylatexstuff/bibliotek.bib']
 let g:pandoc#completion#bib#mode = 'fallback'


"{{{1 SPELLCHECK

set spell
set spelllang=en_us

" Choose first word in list
nmap zz 1z=e

" Command to find and replace repeated word, word duplet or triplet.
command! DoubleWordsCorr %s/\v\c<(\w+(\s|\w)+(\s|\w)+)\s+\1>/\1/gc


" LanguageTool
let g:languagetool_jar='/Applications/LanguageTool-3.6/languagetool-commandline.jar'
let g:languagetool_disable_rules='WHITESPACE_RULE,EN_QUOTES,'
    \ . 'COMMA_PARENTHESIS_WHITESPACE,CURRENCY'

"
"{{{1 DISPLAY
" Display line numbers
set number

" Override conceal applied by varies packages. No pseudo wysywyg here.
autocmd BufEnter * silent! set cole=0


"{{{2 syntax color
colorscheme solarized

" Visibility of invisible chars set list. low|normal|high
let g:solarized_visibility= "medium"

syntax on

" Dark background
set bg=dark

" Remove left and right scrollbar
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Italic comments.
highlight Comment cterm=italic
"}}}2

" No columns to show folds
set foldcolumn=0

" GUIFONTS
"set guifont=Letter\ Gothic:h14 
    " Nice and very bright but no Arabic diacritics.
"set guifont=AnonymousPro:h14 
    " Bright. No arabic diacritics.
" set guifont=Consolas:h14
    " Very nice and has Arabic characters and italics.
set guifont=Source\ Code\ Pro\ Light:h16
   " Has various heavynesses byt no italics
"set guifont=Ubuntu\ Mono:h15
   " Has bold and italics

set linespace=5

" When scrolling, keep the cursor 8 lines from the top and 8
" lines from the bottom
set scrolloff=8

" | at end of chnaged (<c>) object 
set cpoptions+=|

" Soft wrap gundo preview
augroup MyGundo
    au!
    au BufWinEnter __Gundo_Preview__ :setl linebreak wrap
augroup end

" List characters opaque
let g:solarized_visibility='low'


" {{{1 Leader commands

" Window command prefix
nmap <Leader>w <C-w>
" Gundo toggle window
nnoremap <Leader>u :GundoToggle<CR>
" Execute last command
nmap <Leader>c :<Up><CR>
" Next item in location list window
nmap <Leader>nn :lne<CR>

" {{{2 Markdown compilation  

"  to tex
autocmd Filetype pandoc 
            \ nmap <Leader>pt :w<CR>:cd %:p:h<CR>:!pandoc -f markdown+implicit_figures+table_captions % --latex-engine=xelatex --biblatex --bibliography ~/mylatexstuff/bibliotek.bib -s -o '%'.tex<CR>

"  to pdf  
autocmd Filetype pandoc 
            \ nmap <Leader>pp :w<CR>:cd %:p:h<CR>:!pandoc -f
            \ markdown+implicit_figures+table_captions %
            \ --latex-engine=xelatex
            \ --bibliography ~/mylatexstuff/bibliotek.bib
            \ -N -S -o '%'.pdf 
            \ && open '%'.pdf<CR>

"  to docx. -S needed for parsing of daises in non TeX.
autocmd Filetype pandoc
    \ nmap <Leader>pd :w<CR>:cd %:p:h<CR>:!pandoc -f markdown+implicit_figures+table_captions % -S --bibliography ~/mylatexstuff/bibliotek.bib -o '%'.docx<CR>

"  to beamer 
autocmd Filetype pandoc
    \ nmap <Leader>pb :w<CR>:!pandoc -t beamer -f
    \ markdown+implicit_figures+table_captions %
    \ --latex-engine=xelatex
    \ --bibliography ~/mylatexstuff/bibliotek.bib
    \ -S -o '%'.pdf
    \ && open '%'.pdf<CR>

" {{{2 TeX compilation
autocmd Filetype tex
  \ nmap <Leader>pp  :w<CR>:cd %:p:h<CR>:! xelatex --aux-directory=~/latexaux --synctex=1 --src-specials %
  \ && mv '%<'.pdf '%<'.tex.pdf
  \ && open '%'.pdf<CR> 

" Bibtex run
" %< "gives current filename without extension
autocmd Filetype tex nmap <Leader>b :w<CR>:cd %:p:h<CR>:! biber %<<CR>
" OBS!!! Run
"      rm -rf `biber --cache`
" to fix bug crash bug.


" {{{2 Language switching
"
" Switch to Swedish typing
nmap <Leader>s :<C-U>call SweType()<CR>
" Switch to English typing
nmap <Leader>e :<C-U>call EngType()<CR>
" Switch to Arabic typing
nmap <Leader>a :<C-U>call AraType()<CR>


"  Switch to Swedish
function! SweType()
" To switch back from Arabic
  set keymap=swe-us "Modified keymap. File in .vim/keymap
  set norightleft
  set spelllang=sv
endfunction

" Switch to English
function! EngType()
" To switch back from Arabic
  set keymap=us-altlatin "Modified keymap. File in .vim/keymap
  set norightleft
  set spelllang=en_us
endfunction

" Switch to Arabic
function! AraType()
    set keymap=arabic-pc "Modified keymap. File in .vim/keymap
    set rightleft
endfunction

" {{{1 LaTeX mappings
" Mappings only used in .tex files 

autocmd Filetype tex call LaTeXmaps()

function! LaTeXmaps()

  nmap <Leader>sc <ESC>bi\textsc<ESC>lyse}e
  nmap <Leader>ar <ESC>bi\textarabic<ESC>lyse}e
  nmap <Leader>it <ESC>bi\textit<ESC>lyse}e
  nmap <Leader>bf <ESC>bi\textbf<ESC>lyse}e
  nmap <Leader>em <ESC>bi\emph<ESC>lyse}e
  nmap <Leader>ar <ESC>bi\textarabic<ESC>lyse}e
  nmap <Leader>i "iyiwea\index<ESC>lyse}e

  " Input covington example frame.
  nmap <Leader>ce i\begin{example} \label{ex:}<ESC>o\gll <ESC>o<ESC>o\glt `'<ESC>o\speaker{}{}<ESC>o\lineno{}<ESC>o\glend<ESC>o\end{example}<ESC>

  " Input yanked rcode in comment.
  " Requires vim-latex-textobj plugin.
  nmap <Leader>rc i\begin{rcode}<CR>\end{rcode}<ESC>"0Pvae3>


  " Key mapping to Tabularize LaTeX tabular
  " Tabularize by & unless escaped
  " Requires vimtex for `vie` operation  
  map <Leader>t vip:Tabularize /\\\@<!&<CR>

  " Tabularize gloss (by spaces)
  map <Leader>tc vie:s/\v +/ /<CR>vie:Tabularize / <CR>

endfunction

" }}1
" {{{1 Markdown mappings and function
" Mappings only used in markdown files 

autocmd Filetype pandoc call MarkdownMaps()

function! MarkdownMaps()


    " Do comments in Markdown as suggested here http://stackoverflow.com/a/20885980/3210474
    " No comment in HTML or TeX output.
    set commentstring=[//]:\ #\ (%s)

    " Let Tabularize do pipe tables 
    nnoremap <Leader>t vip:Tabularize /\|<CR>

endfunction
" }}}1
" {{{1 DiffChar
" Set wrap in diff
au FilterWritePre * if &diff | set wrap | endif

let g:DiffUpdate = 1
let g:DiffUnit = 'Word3'
let g:DiffModeSync = 1

" Reduce error reports
" autocmd InsertEnter * :RDCha
" autocmd InsertLeave * :TDCha

" }}}
" {{{1 MOVEMENT & EDITING ---------------
" backspace over everything in insert mode
set backspace=indent,eol,start 

" Move on soft-wrapped lines
nnoremap k gk
nnoremap j gj
vnoremap k gk
vnoremap j gj

" Makes h and l and arrow keyes wrap to pre/next line.
set whichwrap+=<,>,h,l,[,]

" Move to win horizontally
nmap HH <C-w>h
nmap LL <C-w>l

" Set undo points at end of sentence.
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap : :<C-g>u
inoremap ; ;<C-g>u

" gundo plugin
" Wider gundo window
    let g:gundo_width = 60
" Auto-close gundo window on revert.
    let g:gundo_close_on_revert=1

nnoremap U :syntax sync fromstart<CR>:redraw!<CR>


" {{{1 CHARACTER INPUT

" Space to insert space character before
nnoremap <Space> i<Space><ESC>

" abbreviation command for common misspellings
iabbrev tow two
iabbrev teh the 
iabbrev Andras Andreas

" Remove word in input mode
" Must go through visual mode to get character under cursor. 
inoremap jj <Esc>ciw
imap <BS><BS> <NOP>

" When inserting empty line, return to cursor position
nnoremap <silent> <Plug>EmptyLineAbove meO<ESC>`e:call repeat#set("\<Plug>EmptyLineAbove")<CR>
nmap O<ESC> <Plug>EmptyLineAbove

" Insert empty line below, repeatable
nnoremap <silent> <Plug>EmptyLineBelow meo<ESC>`e:call repeat#set("\<Plug>EmptyLineBelow")<CR>
nmap o<ESC> <Plug>EmptyLineBelow

" {{{2 Delimiters

" Type delimiters in input withing them. The following space, comma or dot  makes it possible to write '{}' and keep typing
inoremap {} {}<Left>
inoremap () ()<Left>
inoremap [] []<Left>
inoremap <> <><Left>
inoremap ** **<Left>
inoremap "" ""<Left>
inoremap '' ''<Left>

" Normal behaviour if folowed by space, enter, comma, full stop
inoremap {}<Space> {}<Space>
inoremap {}<CR> {}<CR>
inoremap {}, {},
inoremap {}. {}.

inoremap ()<Space> ()<Space>
inoremap ()<CR> ()<CR>
inoremap (), (),
inoremap (). ().

inoremap []<Space> []<Space>
inoremap []<CR> []<CR>
inoremap [], [],
inoremap []. [].

inoremap **<Space> **<Space>
inoremap **<CR> **<CR>
inoremap **, **,
inoremap **. **.

inoremap <><Space> <><Space>
inoremap <><CR> <><CR>
inoremap <>, <>,
inoremap <>. <>.

inoremap ""<Space> ""<Space>
inoremap ""<CR> ""<CR>
inoremap "", "",
inoremap "". "".

inoremap ''<Space> ''<Space>
inoremap ''<CR> ''<CR>
inoremap '', '',
inoremap ''. ''.


"{{{1 LATEX 
"
" See ~/vim/after/syntax/tex.vim for disabling of spellcheck in rcode and

" Vimtex settings
let g:vimtex_complete_close_braces = 1


" From vimtex help
            let g:vimtex_view_general_viewer
                  \ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
            let g:vimtex_view_general_options = '-r @line @pdf @tex'

            " This adds a callback hook that updates Skim after compilation
            let g:vimtex_latexmk_callback_hooks = ['UpdateSkim']
            function! UpdateSkim(status)
              if !a:status | return | endif

              let l:out = b:vimtex.out()
              let l:tex = expand('%:p')
              let l:cmd = [g:vimtex_view_general_viewer, '-r']
              if !empty(system('pgrep Skim'))
                call extend(l:cmd, ['-g'])
              endif
              if has('nvim')
                call jobstart(l:cmd + [line('.'), l:out, l:tex])
              elseif has('job')
                call job_start(l:cmd + [line('.'), l:out, l:tex])
              else
                call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
              endif
            endfunction

" vimtex folding
let g:vimtex_fold_enabled=1

"{{{1 R

" Force Vim to use 256 colors if running in a capable terminal emulator:
if &term =~ "xterm" || &term =~ "256" || $DISPLAY != "" || $HAS_256_COLORS == "yes"
    set t_Co=256
endif


