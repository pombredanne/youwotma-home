set showmode
set smartindent

colorscheme wombat

set lazyredraw " magia

" mostrar siempre la linea de estatus
set laststatus=2

" copiado de http://www.reddit.com/r/vim/comments/e19bu/whats_your_status_line/c14husq
" cambiar el color de la barra de estado si estamos insertando

hi StatusLine cterm=bold ctermfg=white ctermbg=black gui=bold guifg=white guibg=#333333
au InsertEnter * hi StatusLine cterm=bold ctermfg=white ctermbg=black gui=bold guifg=white guibg=#330000
au InsertLeave * hi StatusLine cterm=bold ctermfg=white ctermbg=black gui=bold guifg=white guibg=#333333

" mostrar comandos parciales en la linea de comandos
set showcmd

" permite usar borrar para cualquier tipo de carácter
set backspace=indent,eol,start

" mostrar numero de linea
set nu

" encoding por defecto
set encoding=utf-8

" formato de los saltos de linea
set fileformat=unix

" muestra el paréntesis o llave que cierra el que acabamos de escribir
set showmatch

set complete=.,w,b,t " reglas de auto completado

set ignorecase " no coincidir mayúsculas al buscar
set smartcase " coincidir mayúsculas inteligentemente
set incsearch " buscar modo firefox
set infercase " corregir mayúsculas en la búsqueda

" auto completar comandos
set wildmode=list:longest,full

" mostrar siempre el cursor
set ruler

set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

" resaltar todos los resultados de la búsqueda
set hlsearch

" añadir syntax highlighting
syntax on

" detección de tipo de archivo
filetype plugin on
filetype indent on

" activa el ratón
set mouse=a

" no partir lineas
set nowrap

"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

au BufRead,BufNewFile *.scss set filetype=scss  "resaltado de archivos scss
au BufRead,BufNewFile *.less set filetype=less  "resaltado de archivos less
au BufRead,BufNewFile *.coffee set filetype=coffee  "resaltado de archivos coffee

" Archivos de tags
set tags=~/.stslib-tags,~/.django-tags

" No auto-añadir saltos de linea
set tw=0

" C-Enter abre una nueva linea siempre, aunque este
" el menú de completar abierto
imap <C-Enter> <Esc>o

" Indentación
set ts=4 sts=4 sw=4 expandtab smarttab ai si

" Historia
set history=700

" Lineas de contexto vertical
set so=4

" Completar nombres estilo bash
set wildmenu

" No usar los malditos archivos swap
set noswapfile

imap <C-e> <Esc>mgk$a,<Esc>`ga


if has("gui_running")
    au BufWritePost * :silent !/home/carl/.vim/aftersave.sh "%:p"
    au BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw!


    call pathogen#runtime_append_all_bundles()

    " linea de estado
    set statusline=
    set statusline+=%F%m%h%r%w "Flags varios
    set statusline+=\ %{fugitive#statusline()} " Branch de GIT
    set statusline+=%= "Alinear a la derecha
    set statusline+=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}] " Codificación y tipo de archivo
    set statusline+=\ %12.(%c:%l/%L%) " posición en la pagina

    " quitar barras de menú y de herramientas
    set guioptions-=m
    set guioptions-=T


    " Muestra los espacios al final en rojo
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()


    " pydiction
    let g:pydiction_location = '/home/carl/dev/pydiction/complete-dict'

    " corrección ortográfica
    set spell spelllang=es

    " alias ,t -> tabnew. El espacio al final es intencionado
    map ,t :tabnew 

    " NERDtree
    map <F2> :NERDTreeToggle<CR>
    nnoremap <F4> :GundoToggle<CR>

    "Cuando borro con la x, no escribir en los registros
    map x "_dl
    vmap x "_<Del>

endif
