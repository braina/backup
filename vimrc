"http://deadlinetimer.com/timer/106757
"test

"neobundle
" neobundle settings {{{
if has('vim_starting')
		set nocompatible
		" neobundle をインストールしていない場合は自動インストール
		if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
				echo "install neobundle..."
				" vim からコマンド呼び出しているだけ neobundle.vim のクローン
				:call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
		endif
		" runtimepath の追加は必須
		set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'


NeoBundleFetch 'Shougo/neobundle.vim'

"閉じ括弧自動補完
NeoBundle 'Townk/vim-autoclose'

"jkを加速する
NeoBundle 'rhysd/accelerated-jk'
let g:accelerated_jk_acceleration_table = [10,5,3]
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)

"vimproc非同期処理
NeoBundle 'Shougo/vimproc.vim', {
						\ 'build' : {
						\ 'windows' : 'make -f make_mingw32.mak',
						\ 'cygwin' : 'make -f make_cygwin.mak',
						\ 'mac' : 'make -f make_mac.mak',
						\ 'unix' : 'make -f make_unix.mak',
						\ },
						\ }


" 1見た目を綺麗に
NeoBundle 'itchyny/lightline.vim'

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! LightLineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? '🔒' : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = '' 
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

"ctagsを利用したジャンプリスト
NeoBundle 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>
"保存時ctags自動生成 => :ctags で生成にする。
NeoBundle 'soramugi/auto-ctags.vim'
"let g:auto_ctags = 1


"lookを使った英単語補完
NeoBundle 'ujihisa/neco-look'
"spell 文法のチェック
set spelllang=en,cjk
"http://rhysd.hatenablog.com/entry/2014/12/08/082825
":GrammarousCheck で実行
NeoBundle 'rhysd/vim-grammarous'

"簡単整形
"http://blog.tokoyax.com/entry/vim/vim-easy-align
NeoBundle 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"commentトグル
NeoBundle 'scrooloose/nerdcommenter'
let NERDSpaceDelims = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterToggle
""未対応ファイルタイプのエラーメッセージを表示しない
let NERDShutUp=1


"日本語ヘルプ追加
NeoBundle 'vim-jp/vimdoc-ja'

"undotree可視化
NeoBundle 'sjl/gundo.vim'
nmap gu              :<C-u>GundoToggle<CR>
"いちいちプレビューしない奴 r 押下でプレビューする
"使用感的に微妙なので保留（本家でも3jとかすれば同じといえばおなじ）
"http://d.hatena.ne.jp/heavenshell/20120218/1329532535
"NeoBundle 'https://bitbucket.org/heavenshell/gundo.vim'
"let g:gundo_auto_preview = 0


"インデント表示
NeoBundle 'Yggdroot/indentLine'
let g:indentLine_faster = 1
nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>

"toggle case
"snake case camel case
NeoBundle 'tanabe/ToggleCase-vim'
nnoremap <silent> <C-_> :<C-u>call ToggleCase()<CR>

"Emmet
NeoBundleLazy 'mattn/emmet-vim', {
  \ 'autoload' : {
  \   'filetypes' : ['html', 'html5', 'eruby', 'jsp', 'xml', 'css', 'scss', 'coffee'],
  \   'commands' : ['<Plug>ZenCodingExpandNormal']
  \ }}
" emmet {{{
let g:use_emmet_complete_tag = 1
let g:user_emmet_settings = {
  \ 'lang' : 'ja',
  \ 'html' : {
  \   'indentation' : '  '
  \ }}
" }}}


" emmet {{{
let g:user_emmet_leader_key = '<C-y>'
let g:use_emmet_complete_tag = 1
let g:user_emmet_settings = {
						\ 'variables':{
						\		'lang' : 'ja'
						\ },
						\ 'html' : {
						\   'indentation' : '  '
						\ }}
" }}}

"sudo vim
NeoBundle 'sudo.vim'

"vimでprocessing
NeoBundle 'sophacles/vim-processing'

"vimでcs
NeoBundle 'kchmck/vim-coffee-script'
" vimにcoffeeファイルタイプを認識させる
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee
" インデントを設定
autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et
autocmd BufWritePost *.coffee silent make!

"sass自動コンパイル
NeoBundle 'AtsushiM/search-parent.vim'
NeoBundle 'AtsushiM/sass-compile.vim'
""{{{
let g:sass_compile_auto = 1
let g:sass_compile_cdloop = 5
let g:sass_compile_cssdir = ['css', 'stylesheet']
let g:sass_compile_file = ['scss', 'sass']
let g:sass_compile_beforecmd = ''
let g:sass_compile_aftercmd = ''
"}}}

"ハイライト
NeoBundle 't9md/vim-quickhl'
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

"CSSなどの色をその色でハイライト
"http://blog.scimpr.com/2013/02/24/vim%E3%81%A7css%E3%82%92%E7%B7%A8%E9%9B%86%E3%81%99%E3%82%8B%E3%81%A8%E3%81%8D%E3%81%AB%E8%89%B2%E3%82%92%E3%83%97%E3%83%AC%E3%83%B4%E3%83%A5%E3%83%BC%E3%80%9Ccolorizer/
NeoBundle 'lilydjwg/colorizer'


"tweetvim
NeoBundle 'basyura/TweetVim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'basyura/bitly.vim'
NeoBundle 'Shougo/unite.vim'
filetype plugin indent on
let g:tweetvim_tweet_per_page = 75
nmap tn              :<C-u>TweetVimSay<CR>



"vimquickrun
NeoBundle 'thinca/vim-quickrun'
"quickrun for processing:
let g:quickrun_config = {
			\   "_" : {
			\		'split':'vertical',
			\       "outputter/buffe//close_on_empty" : 1,
			\       "runner" : "vimproc",
			\       "runner/vimproc/updatetime" : 60
			\   },
			\}

let g:quickrun_config.processing =  {
			\     'command': 'processing-java',
			\     'exec': '%c --sketch=$PWD/ --output=$PWD/temp --run --force',
			\   }

let g:quickrun_config['coffee'] = {'command' : 'coffee', 'exec' : ['%c -cbp %s']}
let g:quickrun_config['html'] = { 'command' : 'open', 'exec' : '%c %s', 'outputter': 'browser' }
let g:quickrun_config["java"] = {
			\ 'exec' : ['javac -J-Dfile.encoding=UTF8 %o %s', '%c -Dfile.encoding=UTF8 %s:t:r %a']
			\}



"set splitbelow "新しいウィンドウを下に開く
set splitright "新しいウィンドウを右に開く

"半透明でも見やすく
NeoBundle 'miyakogi/seiya.vim'
let g:seiya_auto_enable=1

"文字列を囲んだり、囲んである文字列を消したり置換したり
NeoBundle 'tpope/vim-surround'

" NeoBundle 'kana/vim-operator-user' 
" NeoBundle 'rhysd/vim-operator-surround'
" map <silent>sa <Plug>(operator-surround-append)
" map <silent>sd <Plug>(operator-surround-delete)
" map <silent>sr <Plug>(operator-surround-replace)

"Tabを便利にするために入れるやつ
NeoBundle 'kana/vim-submode'

"migemo
NeoBundle 'haya14busa/incsearch-migemo.vim'
" マッピング例
map m/ <Plug>(incsearch-migemo-/)
map m? <Plug>(incsearch-migemo-?)
map mg/ <Plug>(incsearch-migemo-stay)

"マルチインクリメントサーチ
NeoBundle 'haya14busa/incsearch.vim'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


"協力な補完機能 neocomplete
NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'

if neobundle#is_installed('neocomplete')
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#enable_ignore_case = 1
	let g:neocomplete#enable_smart_case = 1
	if !exists('g:neocomplete#keyword_patterns')
		let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns._ = '\h\w*'
elseif neobundle#is_installed('neocomplcache')
	let g:neocomplcache_enable_at_startup = 1
	let g:neocomplcache_enable_ignore_case = 1
	let g:neocomplcache_enable_smart_case = 1
	if !exists('g:neocomplcache_keyword_patterns')
		let g:neocomplcache_keyword_patterns = {}
	endif
	let g:neocomplcache_keyword_patterns._ = '\h\w*'
	let g:neocomplcache_enable_camel_case_completion = 1
	let g:neocomplcache_enable_underbar_completion = 1
endif


"snipets
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'

" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
	set conceallevel=2 concealcursor=i
endif

" snippetファイルがまとまっているもの
NeoBundle 'honza/vim-snippets'

"git操作
NeoBundle 'tpope/vim-fugitive'

"controlP でファイル表示
NeoBundle 'ctrlpvim/ctrlp.vim'
let g:ctrlp_use_migemo = 1


"File tree表示
NeoBundle 'scrooloose/nerdtree'
nnoremap <silent><C-e> :NERDTreeToggle<CR>


" 様々な言語を保存時にシンタックスチェック
NeoBundle 'scrooloose/syntastic'
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2
let g:syntastic_mode_map = {'mode': 'active'}
"augroup AutoSyntastic
"		autocmd!
"		autocmd InsertLeave,TextChanged * call s:syntastic() 
"augroup END
"function! s:syntastic()
"		w
"		SyntasticCheck
"endfunction
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 1
let g:syntastic_echo_current_error = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_enable_highlighting = 1
" なんでか分からないけど php コマンドのオプションを上書かないと動かなかった
let g:syntastic_php_php_args = '-l'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_ruby_checkers = ['rubocop'] " or ['rubocop', 'mri']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_coffee_checkers = ['coffeelint']
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '⚠'



"Calender.vim
NeoBundle 'itchyny/calendar.vim'
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1




" vimrc に記述されたプラグインでインストールされていないものがないかチェックする
NeoBundleCheck
call neobundle#end()
filetype plugin indent on



" -----------------------------------------------------------------------------------------------------------------------------------------------------------"



" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup
"行番号表示
set number
"title表示
set title
"tabのスペース設定
set tabstop=4
set softtabstop=4
set shiftwidth=4
"検索結果をハイライトする
set hlsearch
"検索で大文字小文字をくべつしない
set ignorecase	
"ただし混在しているときは区別する
set smartcase


"syntax setting
syntax on
colorscheme molokai
set t_Co=256
"カーソル行の背景色変更
set cursorline
"ステータス行を常に表示 
set laststatus=2

"カーソルが何行目何列に置かれているかの表示
set ruler
"タイプ途中のcommandを表示
set showcmd
"保存されていない時に閉じると確認
set confirm
"1行の文字数制限をなくす
set display=lastline

"</で補完
autocmd FileType html inoremap <silent> <buffer> </ </<C-x><C-o>

"Markdownの拡張子を拡張
set syntax=markdown
au BufRead,BufNewFile *.md set filetype=markdown

"新規行にスマートインデント作成
:set cindent

"行頭行末移動をスペースキーで
nnoremap <Space>h  ^
nnoremap <Space>l  $

"\.vimrcを瞬時に開く
nnoremap <Space><Space>. :e $MYVIMRC<CR>
nnoremap <Space><Space>..  :<C-u>source $MYVIMRC<CR>

"インクリメント・デクリメントの里マッピング
nnoremap + <C-a>
nnoremap - <C-x>

"vim画面分割のキーリマップ
"http://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

"Yを行末までヤンクに変更
nnoremap Y y$

"xで削除した文字はレジスタに突っ込まない
nnoremap x "_x
nnoremap X "_X

"行頭→行末のカーソル移動
set whichwrap+=h,l,<,>,[,],b,s
"visual bellを切る
set visualbell t_vb=
set noerrorbells

"backspaceで消せる文字を増やす
set backspace=indent,eol,start

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

"n/で検索時にヒット数表示
"http://qiita.com/akira-hamada/items/eb46ef02fabfdd418449
nnoremap <expr> n/ _(":%s/<Cursor>/&/gn")

function! s:move_cursor_pos_mapping(str, ...)
    let left = get(a:, 1, "<Left>")
    let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
    return substitute(a:str, '<Cursor>', '', '') . lefts
endfunction

function! _(str)
    return s:move_cursor_pos_mapping(a:str, "\<Left>")
endfunction


""""""""""""""""""""""""""""""
" 全角スペースの表示
""""""""""""""""""""""""""""""
function! ZenkakuSpace()
	highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
	augroup ZenkakuSpace
		autocmd!
		autocmd ColorScheme * call ZenkakuSpace()
		autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
	augroup END
	call ZenkakuSpace()
endif
""""""""""""""""""""""""""""""

"clipboard設定
set clipboard+=unnamed



" https://sites.google.com/site/fudist/Home/vim-nihongo-ban/-vimrc-sample
""""""""""""""""""""""""""""""
" 挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
	augroup InsertHook
		autocmd!
		autocmd InsertEnter * call s:StatusLine('Enter')
		autocmd InsertLeave * call s:StatusLine('Leave')
	augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
	if a:mode == 'Enter'
		silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
		silent exec g:hi_insert
	else
		highlight clear StatusLine
		silent exec s:slhlcmd
	endif
endfunction

function! s:GetHighlight(hi)
	redir => hl
	exec 'highlight '.a:hi
	redir END
	let hl = substitute(hl, '[\r\n]', '', 'g')
	let hl = substitute(hl, 'xxx', '', '')
	return hl
endfunction
""""""""""""""""""""""""""""""

" tmuxにファイル名を渡す
if $TMUX != ""
	augroup titlesettings
		autocmd!
		autocmd BufEnter * call system("tmux rename-window " . "'[vim] " . expand("%:t") . "'")
		autocmd VimLeave * call system("tmux rename-window zsh")
		autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
	augroup END
endif


"undo
set undodir=$HOME/.vim/undo
set undofile
"ClearUndo で undo履歴クリア
command -nargs=0 ClearUndo call <sid>ClearUndo()

"編集箇所保存
function! s:RestoreCursorPostion()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction
" ファイルを開いた時に、以前のカーソル位置を復元する
augroup vimrc_restore_cursor_position
	autocmd!
	autocmd BufWinEnter * call s:RestoreCursorPostion()
augroup END


"Escのききをよくするため、待ち時間を変更
"見た目は変わってないんだけど、多分大丈夫
set timeout timeoutlen=1000 ttimeoutlen=10



if has('gui_macvim')
	set imdisable	" IMを無効化
	lang C
	set helplang=en

	set nobackup
	set guioptions-=T
	set antialias
	set visualbell t_vb=
	set columns=100
	set lines=48


	" Color Scheme
	syntax enable
	colorscheme molokai
	set laststatus=2
	set showcmd
endif
