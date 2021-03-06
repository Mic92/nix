set nocompatible

" Prevent nesting

if $NEOVIM == 'true'
	echo 'Nesting is disabled.'
	q!
endif
let $NEOVIM = 'true'


" Lazy plugins

autocmd FileType lisp :packadd rainbow
autocmd FileType c,cpp :packadd vim-clang-format | :packadd vim-headerguard
autocmd FileType markdown :packadd vim-pandoc-syntax


" Autocomplete

"let g:deoplete#enable_at_startup = 1

" GUI and colors

set mouse=a guicursor= nu rnu noshowmode background=dark
highlight Statement ctermfg=yellow
highlight LineNr ctermfg=darkgrey
highlight CursorLineNr ctermfg=grey
highlight ColorColumn ctermbg=black
highlight FoldColumn ctermbg=none
highlight Pmenu ctermbg=darkgrey


" Keyboard mappings

nmap <C-w> :w<CR>
nmap <C-q> :q<CR>
nmap <C-j> :CF<CR>
imap <C-w> <ESC>:w<CR>i
imap <C-q> <ESC>:q<CR>
imap <C-b> <ESC>diwi
inoremap <silent><expr><CR> pumvisible() ? deoplete#mappings#close_popup()."\<CR>" : "\<CR>"
tnoremap <Esc> <C-\><C-n>

for dirkey in ['h', 'j', 'k', 'l']
	execute 'nnoremap <A-' . dirkey . '> <C-w>' . dirkey
	execute 'inoremap <A-' . dirkey . '> <ESC><C-w>' . dirkey . 'i'
	execute 'tnoremap <A-' . dirkey . '> <C-\><C-n><C-w>' . dirkey . 'i'
endfor


" EasyMotion

let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap W <Plug>(easymotion-w)
nmap B <Plug>(easymotion-b)


" Searching

set ignorecase smartcase

" File type presets

autocmd FileType lisp,arduino,haskell,cabal :setlocal et ts=2 sw=2
autocmd FileType cpp :setlocal ts=2 sw=2 et
autocmd FileType lua :setlocal ts=2 sw=2 et
autocmd FileType cs,php :setlocal ts=4 sw=4 et
autocmd FileType markdown,text,plaintex :setlocal foldcolumn=4 colorcolumn=73 et ts=2 sw=2


" Rainbow parentheses

let g:rainbow_conf = {
\	'separately': {
\		'*': 0,
\		'lisp': {
\			'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\		}
\	}
\}
let g:rainbow_active = 1


" Status bar

let g:lightline = {
\	'active': {
\		'left': [ [ 'mode', 'paste' ],
\			  [ 'readonly', 'buffername', 'modified' ] ],
\		'right': [ [ 'lineinfo' ], [ 'percent' ],
\			   [ 'fileformat', 'fileencoding', 'filetype', "totallines" ] ],
\	},
\	'inactive':{
\		'left': [ [ 'buffername' ] ],
\		'right': [ [ 'lineinfo' ], [ 'percent' ] ]
\	},
\	'component': {
\		'totallines': '%{line("$")}L',
\	},
\	'component_function': {
\		'buffername': 'BufName',
\	},
\}

let g:bufname_cache = {}
function BufName()
	let name = expand('%:p')
	if !has_key(g:bufname_cache, name)
		if name == ''
			let g:bufname_cache[name] = '[new]'
		elseif name =~ 'term:\/\/'
			let g:bufname_cache[name] = expand('%:t')
		else
			let parts = split(name, '/')
			let homeparts = split($HOME, '/')
			let nhparts = len(homeparts)

			let ishome = parts[:nhparts - 1] == homeparts

			if ishome
				call remove(parts, 0, nhparts - 1)
				call insert(parts, '~')
			endif

			let nparts = len(parts)
			let shortparts = []

			for part in parts
				if strpart(part, 0, 1) == '.'
					call add(shortparts, strpart(part, 0, 2))
				else
					call add(shortparts, strpart(part, 0, 1))
				endif
			endfor

			let shortparts[nparts - 1] = parts[nparts - 1]

			let g:bufname_cache[name] = (ishome ? '' : '/') . join(shortparts, '/')
		endif
	endif
	return g:bufname_cache[name]
endfunction

" Clang-Format

let g:clang_format#style_options = {
\	'IndentWidth': 2,
\	'SortIncludes': 'false',
\}


" Commands

command Term :belowright new | :terminal
command Upload :call UploadBuffer()
command Pan :call Pandoc()
command CF :ClangFormat
command CH :HeaderguardAdd

function UploadBuffer()
	let sourcepath = TempPath()
	execute 'w' fnameescape(sourcepath)
	execute 'silent :!upload' fnameescape(sourcepath)
	execute 'silent :!rm' fnameescape(sourcepath)
endfunction

function Pandoc()
	let sourcepath = TempPath()
	if expand('%:p') != ''
		let sourcepath = bufname('%')
	endif
	let outpath = TempPath('pdf')
	execute 'w' sourcepath
	execute 'silent :!pandoc -s --number-sections --table-of-contents -V geometry:margin=2cm -f markdown ' sourcepath '-o' outpath
	if !filereadable(outpath)
		echoerr 'Failed to convert to PDF.'
		return
	endif
	execute 'silent :!open' outpath
endfunction


" Misc functions

function Chomp(str)
	return substitute(a:str, '\n\+$', '', '')
endfunction

function TempPath(...)
	let ext = (a:0 >= 1) ? a:1 : fnamemodify(bufname('%'), ':e')
	let random = Chomp(system('bash -c "echo \$RANDOM"'))
	return '/tmp/' . random . '.' . ext
endfunction
