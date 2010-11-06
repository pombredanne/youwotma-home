set showmode
set smartindent

" mostrar siempre la linea de estatus
set laststatus=2

" copiado de http://www.reddit.com/r/vim/comments/e19bu/whats_your_status_line/c14husq
" cambiar el color de la barra de estado si estamos insertando

hi StatusLine cterm=bold ctermfg=white ctermbg=black gui=bold guifg=white guibg=#333333
au InsertEnter * hi StatusLine cterm=bold ctermfg=white ctermbg=black gui=bold guifg=white guibg=#330000
au InsertLeave * hi StatusLine cterm=bold ctermfg=white ctermbg=black gui=bold guifg=white guibg=#333333

" linea de estado
set statusline=
set statusline+=%F%m%h%r%w "Flags varios
set statusline+=\ %{fugitive#statusline()} " Branch de GIT
set statusline+=%= "Alinear a la derecha
set statusline+=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}] "Codificacion y tipo de archivo
set statusline+=\ %12.(%c:%l/%L%) "posicion en la pagina

" quitar barras de menu y de herramientas
set guioptions-=m
set guioptions-=T

" mostrar comandos parciales en la linea de comandos
set showcmd

" permite usar borrar para cualquier tipo de caracter
set backspace=indent,eol,start

" mostrar numero de linea
set nu

" encoding por defecto
set encoding=utf-8

" formato de los saltos de linea
set fileformat=unix

" muestra el parentesis o llave que cierra el que acabamos de escribir
set showmatch

set complete=.,w,b,t " reglas de autocompletado

set ignorecase " no coincidir mayusculas al buscar
set smartcase " conincidir mayuscular inteligentemente
set incsearch " buscar modo firefox
set infercase " corregir mayusculas en la busqueda 

" autocompletar comandos
set wildmode=list:longest,full

" mostrar siempre el cursor
set ruler

set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

" resaltar todos los resultados de la busqueda
set hlsearch

" añadir syntax highlighting
syntax on

"deteccion de tipo de archivo
filetype plugin on
filetype indent on

" activa el raton
set mouse=a

" no partir lineas
set nowrap

autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
"autocmd FileType python setlocal omnifunc=pysmell#Complete

" Indentacion
set ts=4 sts=4 sw=4 expandtab smarttab ai si 

" Historia
set history=700

" Lineas de contexto vertical
set so=4

" Completar nombres estilo bash
set wildmenu

" No usar los malditos archivos swap
set noswapfile
