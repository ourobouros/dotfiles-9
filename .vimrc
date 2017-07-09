if has('nvim')
  let vimplugdir='~/.config/nvim/plugged'
  let vimautoloaddir='~/.config/nvim/autoload'
  " TODO: pip2 install neovim
  " TODO: pip3 install neovim
else
  let vimplugdir='~/.vim/plugged'
  let vimautoloaddir='~/.vim/autoload'
endif

" TODO: make swapfiles reside in one directory
"
if empty(glob(vimautoloaddir . '/plug.vim'))
  " TODO: else?
  if executable('curl')
    execute 'silent !curl -fLo ' . vimautoloaddir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall
  endif
endif

""
"" Helper functions
""
function! BrewWrap(command)
  if executable('brew')
    execute "!brew sh <<<'" . a:command . "'"
  else
    execute "!" . a:command
  endif
endfunction

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.status == 'updated' || a:info.force
    let l:cmd = './install.py'
    if executable('go')
      let l:cmd .= ' --gocode-completer'
    endif
    if executable('cargo')
      let l:cmd .= ' --racer-completer'
    endif
    " Those two are not very nice yet
"    if executable('xbuild') || executable('msbuild')
"      let l:cmd .= ' --omnisharp-completer'
"    endif
    if executable('npm') && executable('tern')
      let l:cmd .= ' --tern-completer'
    endif
    if executable('clang')
      let l:cmd .= ' --clang-completer'
      let l:cmd = '(export CC=$(which clang); export CXX=$(which clang++); ' . l:cmd . ')'
    endif
    " FIXME: Make it return the success/failure of an installation
    execute BrewWrap(l:cmd)
  endif
endfunction

function! InstallTern(info)
  if executable('brew') && !executable('npm')
    execute "!brew install node"
  endif
  if executable('npm')
    execute "!npm install"
  endif
endfunction

function! UpdateRemote(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    UpdateRemotePlugins
    echom "Remember to restart!"
  endif
endfunction

try
call plug#begin(vimplugdir)

" Neovim is sensible by default
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
if has('python')
  Plug 'neilagabriel/vim-geeknote'
endif

" Make sure you use single quotes
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'tpope/vim-tbone'
Plug 'junegunn/vim-peekaboo'
" I see your true colors...
Plug 'junegunn/seoul256.vim'
" Fuzzy searching
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" Git goodies
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
" The NerdTree
Plug 'scrooloose/nerdtree' | Plug 'jistr/vim-nerdtree-tabs'
" Nice colours for our Vim
Plug 'iCyMind/NeoSolarized'
" Man browser for Vim
Plug 'bruno-/vim-man'
" Without you, I'm nothing
if (version == 704 && has('patch154')) || (version > 704) || (has('nvim'))
  if executable('cmake') && executable('python') && executable('make') && executable('cc') && executable('c++')
    Plug 'Valloric/YouCompleteMe', {'do': function('BuildYCM')}
  else
    echo 'YouCompleteMe requires: cmake, python, make, cc and c++'
  end
else
  echo 'This Vim version is not supported by YouCompleteMe'
endif
" Local configuration for projects
Plug 'embear/vim-localvimrc'
" Dockerfile support
Plug 'ekalinin/Dockerfile.vim'
" Automatic generation of CTags
Plug 'vim-misc' | Plug 'xolox/vim-easytags'
" Automatic update of CTags
Plug 'craigemery/vim-autotag'
" Nice browser for CTags
Plug 'majutsushi/tagbar'
" Tmux .conf
Plug 'tmux-plugins/vim-tmux'
" Tmux Focus Events
Plug 'tmux-plugins/vim-tmux-focus-events'
" Nice status bar
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
" Automatically save session
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
" Highlight trailing whitespace
Plug 'ntpeters/vim-better-whitespace'
" Vim color scheme designed to be very readable in both light and dark
" environments.
Plug 'gregsexton/Atom'
" Git explorer
Plug 'gregsexton/gitv'
" Ability to :SudoWrite? Priceless!
Plug 'tpope/vim-eunuch'
" Some syntax checking maybe?
"Plug 'vim-syntastic/syntastic'
" Close all buffers but current
Plug 'muziqiushan/bufonly'
" Motions and objects learned from
" https://blog.petrzemek.net/2016/04/06/things-about-vim-i-wish-i-knew-earlier/
Plug 'tomtom/tcomment_vim'
Plug 'christoomey/vim-sort-motion'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-surround'
" Magit
Plug 'jreybert/vimagit'
" And gitgutter
Plug 'airblade/vim-gitgutter'
" Ruby goodness
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
" Automatically detect indentation
Plug 'tpope/vim-sleuth'

" Send commands to a tmux pane
Plug 'jgdavey/tslime.vim'

" When you need some focus
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" Which Tags are the best?
Plug 'lyuts/vim-rtags'

" Ansible support
Plug 'chase/vim-ansible-yaml'

" Nginx highliting
Plug 'fatih/vim-nginx'

" Auto-close scopes
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-endwise'

" JavaScript support
Plug 'jelera/vim-javascript-syntax'
Plug 'pangloss/vim-javascript'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'marijnh/tern_for_vim', {'do': function('InstallTern')}
Plug 'janko-m/vim-test'

Plug 'lambdatoast/elm.vim'

Plug 'mhinz/vim-grepper'

Plug 'tpope/vim-markdown'

Plug 'fmoralesc/nlanguagetool.nvim'

Plug 'ron89/thesaurus_query.vim'

Plug 'rhysd/nyaovim-markdown-preview'

Plug 'janko-m/vim-test'

Plug 'lambdatoast/elm.vim'

Plug 'mhinz/vim-grepper'

Plug 'tpope/vim-markdown'

Plug 'fmoralesc/nlanguagetool.nvim'

Plug 'ron89/thesaurus_query.vim'

Plug 'rhysd/nyaovim-markdown-preview'

" " CoffeeScript support in Vim
" Bundle 'kchmck/vim-coffee-script'
" " EasyMotion
" Bundle 'Lokaltog/vim-easymotion'
" " Vim Outliner
" Bundle 'vimoutliner/vimoutliner'
" " Python mode
" Bundle 'klen/python-mode'
" " What's a snake without Jedi powers?
" Bundle 'DoomHammer/jedi-vim'
" " Jade support
" Bundle 'jade.vim'
" " VCS
" Bundle 'vcscommand.vim'
" " C# Compiler support
" Bundle 'gmcs.vim'
" " Compilation of lonely files
" Bundle 'SingleCompile'
" " EditorConfig
" Bundle 'editorconfig/editorconfig-vim'

if has('nvim')
  " Great lldb interface for neovim
  Plug 'critiqjo/lldb.nvim', { 'do': function('UpdateRemote') }
  " Asynchronous make for neovim
  Plug 'neomake/neomake'
  " Popup terminal
  Plug 'kassio/neoterm'
  if has('gui')
    Plug 'equalsraf/neovim-gui-shim'
  endif
endif

call plug#end()
catch
  " source ~/.vimrc
endtry

"""
""" Now configure those plugins
"""

""
"" AgGrep (via:
"" https://gist.github.com/manasthakur/5afd3166a14bbadc1dc0f42d070bd746
"" )
""

let g:grepper = {}
nnoremap <leader>G :Grepper<cr>
let g:grepper = { 'next_tool': '<leader>g' }
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
nnoremap <leader>* :Grepper -tool ag -cword -noprompt<cr>


if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
  set grepformat^=%f:%l:%c:%m   " file:line:column:message
  let g:grepper.ag = { 'grepprg': 'ag --vimgrep --smart-case' }
  cnoreabbrev ag GrepperAg
  cnoreabbrev aG GrepperAg
"  cnoreabbrev Ag GrepperAg
endif

function! MySearch()
  let grep_term = input("Enter search term: ")
  if !empty(grep_term)
    execute 'silent grep' grep_term | copen
  else
    echo "Empty search term"
  endif
  redraw!
endfunction

command! Search call MySearch()
nnoremap <leader>f :Search<CR>

nnoremap <leader>* :silent grep <cword> \| copen<CR><C-l>

""
"" }}} AgGrep
""

"cnoreabbrev AG Ack
"cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

"map <Leader>n <plug>NERDTreeTabsToggle<CR>
map <Leader>n <plug>NERDTreeToggle<CR>

set tags=./tags,.vimtags,~/.vim/tags;
set conceallevel=1
set foldmethod=syntax
set pastetoggle=<F2>

let g:easytags_async=1
let g:easytags_file="~/.vim/tags"
let g:easytags_dynamic_files=2
let g:easytags_suppress_ctags_warning=1

" Tagbar definitions
let g:tagbar_type_ansible = {
    \ 'ctagstype' : 'ansible',
    \ 'kinds' : [
        \ 't:tasks'
    \ ],
    \ 'sort' : 0
    \ }

let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : 'markdown2ctags',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" Default fzf layout
let g:fzf_layout = { 'down': '40%' }

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Session settings
set sessionoptions=buffers,curdir,folds,help,resize,tabpages,winpos,winsize

let g:prosession_on_startup = 1
let g:prosession_tmux_title = 1


let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }

" Show docs
let g:javascript_plugin_jsdoc = 1
" Enable keyboard shortcuts
let g:tern_map_keys=1
" Show argument hints
let g:tern_show_argument_hints='on_hold'
" No Flow as yet (https://flowtype.org/)
" let g:javascript_plugin_flow = 1

let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"

" Match block delimiters for Ruby and C-like languages
let b:delimitMate_expand_cr = 1
execute "inoremap {<CR> {<CR>}<ESC>O"

function! s:goyo_enter()
  if exists('$TMUX')
    " Hide the status panel and zoom in the current pane
    silent !tmux set status off
    " This hackery checks whether the pane is zoomed and toggles the status if
    " not
    silent !tmux list-panes -F '\#F'|grep -q Z || tmux resize-pane -Z
  endif
  " All eyes on me
  Limelight
  " Resize after zoom
  if !exists("g:goyo_width")
    let g:goyo_width=80
  endif
  if !exists("g:goyo_height")
    let g:goyo_height='85%'
  endif
  execute "Goyo ".g:goyo_width."x".g:goyo_height
  set scrolloff=999
endfunction

function! s:goyo_leave()
  if exists('$TMUX')
    " Show the status panel and zoom out the current pane
    silent !tmux set status on
    silent !tmux list-panes -F '\#F'|grep -q Z && tmux resize-pane -Z
  endif

  Limelight!
  set scrolloff=5
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

if has('nvim')
  autocmd! BufReadPost,BufWritePost * Neomake
  autocmd! VimLeave * let g:neomake_verbose = 0
endif

autocmd BufRead,BufNewFile *.{markdown,md,mkd} call SetMarkdownOptions()
function! SetMarkdownOptions()
  setlocal filetype=markdown
  setlocal spell
  highlight clear SpellBad
  highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
  setlocal fo+=t
  setlocal fo-=l
  setlocal textwidth=80

  nnoremap <Leader>cs :ThesaurusQueryReplaceCurrentWord<CR>
  vnoremap <Leader>cs y:ThesaurusQueryReplace <C-r>"<CR>"

  if winnr('$') == 1
    Goyo 80
  elseif exists('#goyo')
    Goyo!
  endif
endfunction

autocmd FileType ruby call SetRubyOptions()
function! SetRubyOptions()
  compiler ruby
  setlocal expandtab
  setlocal tabstop=2 shiftwidth=2 softtabstop=2
  setlocal autoindent
endfunction

autocmd FileType gitcommit call SetGitComitOptions()
function! SetGitCommitOptions()
  setlocal spell
  setlocal textwidth=72
endfunction()

" Configure tslime
" Currently you have to manually open a pane and enter its number when first
" run. It might be a better idea to open one automatically
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1

" vim-rspec mappings
nmap <silent> <leader>s :TestNearest<CR>
nmap <silent> <leader>r :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
let test#strategy = "neoterm"

autocmd filetype python set expandtab

"""
""" Misc definitions
"""

set scrolloff=5

"""
""" Colorscheme
"""
set background=dark
try
  colorscheme NeoSolarized
catch
  colorscheme desert
endtry
let g:airline_theme='solarized'
let g:limelight_conceal_ctermfg = 245 " Solarized Base1
let g:limelight_conceal_guifg = '#8a8a8a' " Solarized Base1

"""
""" Fun with buffers
""" Based on https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
"""
set hidden

" To open a new empty buffer
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
" FIXME: not good for modified buffers
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>bQ :bp <BAR> bd! #<CR>

" Show all open buffers with FZF
nmap <leader>bl :Buffers<CR>

" Default GitGutter mappings clash with buffer navigation
map <leader>ga <Plug>GitGutterStageHunk
map <leader>gu <Plug>GitGutterUndoHunk

nmap <leader>] :Goyo<CR>

"""
""" Visually indicate long columns
""" Taken from https://www.youtube.com/watch?v=aHm36-na4-4
"""
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

nmap <leader>t :TagbarToggle<CR>
nmap <leader>n :NERDTreeToggle<CR>

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy).
noremap Y y$

" In command mode (i.e. after pressing ':'), expand %% to the path of the current
" buffer. This allows you to easily open files from the same directory as the
" currently opened file.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation.
vnoremap < <gv
vnoremap > >gv

" Better motions with wrapped lines
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

nmap <leader>x :TComment<CR>

set shiftwidth=2
set softtabstop=2

" Better autocompletion for filenames, buffers, colors, etc.
set wildmenu
set wildmode=longest:full,full

set list
set listchars=tab:▸\ 

set clipboard=unnamed

" Use ; just like :
nnoremap ; :

" Easy moves through wrapped lines
nnoremap j gj
nnoremap k gk

" Prefer A-a as C-a is taken by Tmux/Screen
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

" Hide last search highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Work with tmux mouse integration
set mouse=a

if has('nvim')
  set ttimeout
  set ttimeoutlen=0

  tnoremap <Esc> <C-\><C-n>
endif

if has('gui')
  Guifont DejaVu Sans Mono:h13
endif

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
