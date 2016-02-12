" =============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================
	let g:iswindows = 0
	let g:islinux = 0
	if(has("win32") || has("win64") || has("win95") || has("win16"))
		let g:iswindows = 1
	else
		let g:islinux = 1
	endif
	
	if has("gui_running")
		let g:isGUI = 1
	else
		let g:isGUI = 0
	endif

" =============================================================================
"                          << 以下为软件默认配置 >>
" =============================================================================
	"  < Windows Gvim 默认配置> 做了一点修改
	" -----------------------------------------------------------------------------
	if (g:iswindows && g:isGUI)
		source $VIMRUNTIME/vimrc_example.vim
		source $VIMRUNTIME/mswin.vim
		behave mswin
		set diffexpr=MyDiff()

		function MyDiff()
			let opt = '-a --binary '
			if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
			if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
			let arg1 = v:fname_in
			if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
			let arg2 = v:fname_new
			if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
			let arg3 = v:fname_out
			if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
			let eq = ''
			if $VIMRUNTIME =~ ' '
				if &sh =~ '\<cmd'
					let cmd = '""' . $VIMRUNTIME . '\diff"'
					let eq = '"'
				else
					let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
				endif
			else
				let cmd = $VIMRUNTIME . '\diff'
			endif
			silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
		endfunction
	endif

	"  < Linux Gvim/Vim 默认配置> 做了一点修改
	" -----------------------------------------------------------------------------
	if g:islinux
		set hlsearch        "高亮搜索
		set incsearch       "在输入要搜索的文字时，实时匹配

		" Uncomment the following to have Vim jump to the last position when
		" reopening a file
		if has("autocmd")
			au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
		endif

		if g:isGUI
			" Source a global configuration file if available
			if filereadable("/etc/vim/gvimrc.local")
				source /etc/vim/gvimrc.local
			endif
		else
			" This line should not be removed as it ensures that various options are
			" properly set to work with the Vim-related packages available in Debian.
			runtime! debian.vim

			" Vim5 and later versions support syntax highlighting. Uncommenting the next
			" line enables syntax highlighting by default.
			if has("syntax")
				syntax on
			endif

			set mouse=a                    " 在任何模式下启用鼠标
			set t_Co=256                   " 在终端启用256色
			set backspace=2                " 设置退格键可用

			" Source a global configuration file if available
			if filereadable("/etc/vim/vimrc.local")
				source /etc/vim/vimrc.local
			endif
		endif
	endif


" =============================================================================
"                          << 以下为用户自定义配置 >>
" =============================================================================
	"  < Vundle 插件管理工具配置 >
	" -----------------------------------------------------------------------------
	" 用于更方便的管理vim插件，具体用法参考 :h vundle 帮助
	set nocompatible                                      "禁用 Vi 兼容模式
	filetype off                                          "禁用文件类型侦测
	au BufRead,BufNewFile *.go set filetype=go
	if g:islinux
        set rtp+=~/.vim/bundle/Vundle.vim
	else
        set rtp+=$HOME/.vim/bundle/Vundle.vim
	endif
    call vundle#begin()
        if filereadable(expand("$HOME/.vim/vimrc.bundles"))
          source $HOME/.vim/vimrc.bundles
        endif    
    call vundle#end()
	filetype plugin indent on "required!
	
	"  < 编码配置 >
	" -----------------------------------------------------------------------------
	" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
	set encoding=utf-8                                    "设置gvim内部编码
	set fileencoding=utf-8                                "设置当前文件编码
	set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码

	" 文件格式，默认 ffs=dos,unix
	set fileformat=unix                                   "设置新文件的<EOL>格式
	set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型

	"""""""""""""""""""""""""""
	" 解决Windows图形界面乱码问题
	"""""""""""""""""""""""""""
	if (g:iswindows && g:isGUI)
		"解决菜单乱码
		source $VIMRUNTIME/delmenu.vim
		source $VIMRUNTIME/menu.vim
		"解决consle输出乱码
		language messages zh_CN.utf-8
	endif

	"VIM选项ambiwidth:对不明宽度字符的处理方式；VIM 6.1.455后引入
	:set ambiwidth=double

	"  < 编写文件时的配置 >
		filetype on                                           "启用文件类型侦测
		filetype plugin on                                    "针对不同的文件类型加载对应的插件
		filetype plugin indent on                             "启用缩进
		set smartindent                                       "启用智能对齐方式
		set tabstop=4                                         "设置Tab键的宽度
		set shiftwidth=4                                      "换行时自动缩进4个空格
		set expandtab                                         "将Tab键转换为空格
		set smarttab                                          "指定按一次backspace就删除shiftwidth宽度的空格
		"--------------------折叠--------------------  
        set foldenable                                        "启用折叠
        set foldmethod=indent                                "相同缩进距离的行构成折叠
        set foldlevelstart=2                                  "打开文件是默认不折叠代码
        setlocal foldlevel=99                                  "设置折叠层数为
        set foldcolumn=0                                      "设置折叠区域的宽度
        "set foldmethod=manual                                "手动建立折叠
        "set foldmethod=syntax                                 "使用语法高亮定义代码折叠
        "set foldmethod=marker                                "标志用于指定折叠
		"--------------------折叠--------------------  
		" Linebreak on 500 characters
		set lbr
		set tw=500

		"set Auto indent
		set ai 
		" 用空格键来开关折叠
		nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
		" 当文件在外部被修改，自动更新该文件
		set autoread
		" 常规模式下输入 cS 清除行尾空格
		nmap cS :%s/\s\+$//g<CR>:noh<CR>
		" 常规模式下输入 cM 清除行尾 ^M 符号
		nmap cM :%s/\r$//g<CR>:noh<CR>
		set ignorecase                                        "搜索模式里忽略大小写
		set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
		" set noincsearch                                       "在输入要搜索的文字时，取消实时匹配

		" Ctrl + K 插入模式下光标向上移动
		imap <c-k> <Up>

		" Ctrl + J 插入模式下光标向下移动
		imap <c-j> <Down>

		" Ctrl + H 插入模式下光标向左移动
		imap <c-h> <Left>

		" Ctrl + L 插入模式下光标向右移动
		imap <c-l> <Right>

		" 启用每行超过80列的字符提示（字体变蓝并加下划线），不启用就注释掉
		"au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

	"  < 界面配置 >
		set number                                            "显示行号
		set laststatus=2                                      "启用状态栏信息
		set cmdheight=2                                       "设置命令行的高度为2，默认为1
		set cursorline                                        "突出显示当前行
		set guifont=Hack\ Regular
		set guifontwide=YaHei_Consolas_Hybrid:h10                 "设置字体:字号（字体名称空格用下划线代替）
		"set nowrap                                            "设置不自动换行
		"set shortmess=atI                                     "去掉欢迎界面
		set statusline=%n:%{HasPaste()}%F%m%r%h\ %w\ \(%l\,%c\)\ ascii:%b\ hex:%B\ %P   "设置状态栏信息
		" 设置 gVim 窗口初始位置及大小
		if g:isGUI
			" au GUIEnter * simalt ~x                           "窗口启动时自动最大化
			" winpos 100 10                                     "指定窗口出现的位置，坐标原点在屏幕左上角
			" set lines=38 columns=120                          "指定窗口大小，lines为高度，columns为宽度
			" 设置代码配色方案
			set background=dark
			colorscheme Solarized "Gvim配色方案
			" 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
			set guioptions-=m
			set guioptions-=T
			set guioptions-=r
			set guioptions-=L
			map <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
				\set guioptions-=m <Bar>
				\set guioptions-=T <Bar>
				\set guioptions-=r <Bar>
				\set guioptions-=L <Bar>
			\else <Bar>
				\set guioptions+=m <Bar>
				\set guioptions+=T <Bar>
				\set guioptions+=r <Bar>
				\set guioptions+=L <Bar>
			\endif<CR>
		else
			set background=dark
			colorscheme Solarized "终端配色方案
		endif

	"  < 其它配置 >
		"set writebackup                             "保存文件前建立备份，保存成功后删除该备份
		" Turn backup off, since most stuff is in SVN, git et.c anyway...
		set nowb
		set noswapfile                              "设置无临时文件
		" Sets how many lines of history VIM has to remember
		set history=5000
		set ch=1
		filetype indent on

" =============================================================================
"                          << 以下为常用插件配置 >>
" =============================================================================
	"  < a.vim 插件配置 >
		" 用于切换C/C++头文件
		" :A     ---切换头文件并独占整个窗口
		" :AV    ---切换头文件并垂直分割窗口
		" :AS    ---切换头文件并水平分割窗口

	"  < Align 插件配置 >
	" 一个对齐的插件，用来——排版与对齐代码，功能强大，不过用到的机会不多

	"  < auto-pairs 插件配置 >
	" 用于括号与引号自动补全，不过会与函数原型提示插件echofunc冲突
	" 所以我就没有加入echofunc插件

	"  < BufExplorer 插件配置 >
		" 快速轻松的在缓存中切换（相当于另一种多个文件间的切换方式）
		" <Leader>be 在当前窗口显示缓存列表并打开选定文件
		" <Leader>bs 水平分割窗口显示缓存列表，并在缓存列表窗口中打开选定文件
		" <Leader>bv 垂直分割窗口显示缓存列表，并在缓存列表窗口中打开选定文件

	"  < ccvext.vim 插件配置 >
		" 用于对指定文件自动生成tags与cscope文件并连接
		" 如果是Windows系统, 则生成的文件在源文件所在盘符根目录的.symbs目录下(如: X:\.symbs\)
		" 如果是Linux系统, 则生成的文件在~/.symbs/目录下
		" 具体用法可参考www.vim.org中此插件的说明
		" <Leader>sy 自动生成tags与cscope文件并连接
		" <Leader>sc 连接已存在的tags与cscope文件

	"  < cSyntaxAfter 插件配置 >
		" 高亮括号与运算符等
		au! BufRead,BufNewFile,BufEnter *.{c,cpp,h,java,javascript} call CSyntaxAfter()

	"  < indentLine 插件配置 >
		" 用于显示对齐线，与 indent_guides 在显示方式上不同，根据自己喜好选择了
		" 在终端上会有屏幕刷新的问题，这个问题能解决有更好了
		" 开启/关闭对齐线
		nmap <leader>il :IndentLinesToggle<CR>
		" 设置Gvim的对齐线样式
		if g:isGUI
			let g:indentLine_char = "┊"
			let g:indentLine_first_char = "┊"
		endif
		" 设置终端对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
		let g:indentLine_color_term = 239
		" 设置 GUI 对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
		" let g:indentLine_color_gui = '#A4E57E'

	"  < Mark--Karkat（也就是 Mark） 插件配置 >
	" 给不同的单词高亮，表明不同的变量时很有用，详细帮助见 :h mark.txt

	" "  < MiniBufExplorer 插件配置 >
	" " 快速浏览和操作Buffer
	" " 主要用于同时打开多个文件并相与切换
	" " let g:miniBufExplMapWindowNavArrows = 1     "用Ctrl加方向键切换到上下左右的窗口中去
	" let g:miniBufExplMapWindowNavVim = 1        "用<C-k,j,h,l>切换到上下左右的窗口中去
	" let g:miniBufExplMapCTabSwitchBufs = 1      "功能增强（不过好像只有在Windows中才有用）
	" "                                            <C-Tab> 向前循环切换到每个buffer上,并在但前窗口打开
	" "                                            <C-S-Tab> 向后循环切换到每个buffer上,并在当前窗口打开
	" 在不使用 MiniBufExplorer 插件时也可用<C-k,j,h,l>切换到上下左右的窗口中去
	" Ctrl + K 正常模式下窗口向上移动
	noremap <c-k> <c-w>k
	" Ctrl + J 正常模式下窗口向下移动
	noremap <c-j> <c-w>j
	" Ctrl + H 正常模式下窗口向左移动
	noremap <c-h> <c-w>h
	" Ctrl + L 正常模式下窗口向右移动
	noremap <c-l> <c-w>l

	"  < neocomplcache 插件配置 >
	" 关键字补全、文件路径补全、tag补全等等，各种，非常好用，速度超快。
	let g:neocomplcache_enable_at_startup = 1     "vim 启动时启用插件
	" let g:neocomplcache_disable_auto_complete = 1 "不自动弹出补全列表
	" 在弹出补全列表后用 <c-p> 或 <c-n> 进行上下选择效果比较好

	"  < nerdcommenter 插件配置 >
	" 我主要用于C/C++代码注释(其它的也行)
	" 以下为插件默认快捷键，其中的说明是以C/C++为例的，其它语言类似
	" <Leader>ci 以每行一个 /* */ 注释选中行(选中区域所在行)，再输入则取消注释
	" <Leader>cm 以一个 /* */ 注释选中行(选中区域所在行)，再输入则称重复注释
	" <Leader>cc 以每行一个 /* */ 注释选中行或区域，再输入则称重复注释
	" <Leader>cu 取消选中区域(行)的注释，选中区域(行)内至少有一个 /* */
	" <Leader>ca 在/*...*/与//这两种注释方式中切换（其它语言可能不一样了）
	" <Leader>cA 行尾注释
	let NERDSpaceDelims = 1                     "在左注释符之后，右注释符之前留有空格

	"  < nerdtree 插件配置 >
	" 有目录村结构的文件浏览插件
	" 常规模式下输入 F1 调用插件
	nmap <F1> :NERDTreeToggle<CR>
    " 当打开 NERDTree 窗口时，自动显示 Bookmarks
    let NERDTreeShowBookmarks=1

	"  < omnicppcomplete 插件配置 >
	" 用于C/C++代码补全，这种补全主要针对命名空间、类、结构、共同体等进行补全，详细
	" 说明可以参考帮助或网络教程等
	" 使用前先执行如下 ctags 命令（本配置中可以直接使用 ccvext 插件来执行以下命令）
	" ctags -R --c++-kinds=+p --fields=+iaS --extra=+q
	" 我使用上面的参数生成标签后，对函数使用跳转时会出现多个选择
	" 所以我就将--c++-kinds=+p参数给去掉了，如果大侠有什么其它解决方法希望不要保留呀
	set completeopt=menu                        "关闭预览窗口

	"  < powerline 插件配置 >
	" 状态栏插件，更好的状态栏效果

	"  < repeat 插件配置 >
	" 主要用"."命令来重复上次插件使用的命令

	"  < snipMate 插件配置 >
	" 用于各种代码补全，这种补全是一种对代码中的词与代码块的缩写补全，详细用法可以参
	" 考使用说明或网络教程等。不过有时候也会与 supertab 插件在补全时产生冲突，如果大
	" 侠有什么其它解决方法希望不要保留呀

	"  < SrcExpl 插件配置 >
	" 增强源代码浏览，其功能就像Windows中的"Source Insight"
	" 查看源码的声明
	nmap <F3> :SrcExplToggle<CR>                "打开/闭浏览窗口

	" "  < supertab 插件配置 >
	" " 我主要用于配合 omnicppcomplete 插件，在按 Tab 键时自动补全效果更好更快
	" " let g:supertabdefaultcompletiontype = "<c-x><c-u>"

	"  < std_c 插件配置 >
	" 用于增强C语法高亮
	" 启用 // 注视风格
	let c_cpp_comments = 0

	"  < surround 插件配置 >
	" 快速给单词/句子两边增加符号（包括html标签），缺点是不能用"."来重复命令
	" 不过 repeat 插件可以解决这个问题，详细帮助见 :h surround.txt

	"  < Syntastic 插件配置 >
	" 用于保存文件时查检语法

	"  < Tagbar 插件配置 >
	" 相对 TagList 能更好的支持面向对象

	" 常规模式下输入 tb 调用插件，如果有打开 TagList 窗口则先将其关闭
	nmap tb :TlistClose<CR>:TagbarToggle<CR>

	let g:tagbar_width=30                       "设置窗口宽度
	" let g:tagbar_left=1                         "在左侧窗口中显示

	"  < TagList 插件配置 >
	" 高效地浏览源码, 其功能就像vc中的workpace
	" 那里面列出了当前文件中的所有宏,全局变量, 函数名等

	" 常规模式下输入 tl 调用插件，如果有打开 Tagbar 窗口则先将其关闭
	nmap tl :TagbarClose<CR>:Tlist<CR>

	let Tlist_Show_One_File=1                   "只显示当前文件的tags
	" let Tlist_Enable_Fold_Column=0              "使taglist插件不显示左边的折叠行
	let Tlist_Exit_OnlyWindow=1                 "如果Taglist窗口是最后一个窗口则退出Vim
	let Tlist_File_Fold_Auto_Close=1            "自动折叠
	let Tlist_WinWidth=30                       "设置窗口宽度
	let Tlist_Use_Right_Window=1                "在右侧窗口中显示

	"  < txtbrowser 插件配置 >
	" 用于文本文件生成标签与与语法高亮（调用TagList插件生成标签，如果可以）
	au BufRead,BufNewFile *.txt setlocal ft=txt

	"  < ZoomWin 插件配置 >
	" 用于分割窗口的最大化与还原
	" 常规模式下按快捷键 <c-w>o 在最大化与还原间切换

	" < Gundo 插件配置 >
	"To Toggle the Gundo Windows
	nmap <silent><F12> :GundoToggle<CR>



" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
" 设置<leader>的映射键
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

"Hide the mouse when typing text
set mousehide

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" => VIM user interface
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" Set 7 lines to the cursor - when moving vertically using j/k
		set so=7

	" Turn on the WiLd menu
		set wildmenu

	" Ignore compiled files
		set wildignore=*.o,*~,*.pyc

	"Always show current position
		set ruler

	" Height of the command bar
		set cmdheight=1

	" A buffer becomes hidden when it is abandoned
		set hid

	" Configure backspace so it acts as it should act
		set backspace=eol,start,indent
		set whichwrap+=<,>,h,l

	" Don't redraw while executing macros (good performance config)
		set lazyredraw

	" For regular expressions turn magic on
		set magic

	" Show matching brackets when text indicator is over them
		set showmatch
	" How many tenths of a second to blink when matching brackets
		set mat=2

	" No annoying sound on errors
		set noerrorbells
		set novisualbell
		set t_vb=       "关闭提示音
		set tm=500

	" => Visual mode related
	""""""""""""""""""""""""""""""
		" Visual mode pressing * or # searches for the current selection
		" Super useful! From an idea by Michael Naumann
		vnoremap <silent> * :call VisualSelection('f')<CR>
		vnoremap <silent> # :call VisualSelection('b')<CR>


	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" => Moving around, tabs, windows and buffers
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" Treat long lines as break lines (useful when moving around in them)
	map j gj
	map k gk

	" Disable highlight when <leader><cr> is pressed
	map <silent> <leader><cr> :noh<cr>

	" Close the current buffer
	map <leader>bd :Bclose<cr>

	" Close all the buffers
	map <leader>ba :1,1000 bd!<cr>

	" Useful mappings for managing tabs
	map <leader>tn :tabnew<cr>
	map <leader>to :tabonly<cr>
	map <leader>tc :tabclose<cr>
	map <leader>tm :tabmove

	" Opens a new tab with the current buffer's path
	" Super useful when editing files in the same directory
	map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

	" Switch CWD to the directory of the open buffer
	map <leader>cd :cd %:p:h<cr>:pwd<cr>

	" Specify the behavior when switching between buffers 
	try
	set switchbuf=useopen,usetab,newtab
	set stal=2
	catch
	endtry

	" Return to last edit position when opening files (You want this!)
	" autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif
	" Remember info about open buffers on close
	set viminfo^=%


	" => Editing mappings
		" Remap VIM 0 to first non-blank character
		map 0 ^

		" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
		nmap <M-j> mz:m+<cr>`z
		nmap <M-k> mz:m-2<cr>`z
		vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
		vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

		if has("mac") || has("macunix")
			nmap <D-j> <M-j>
			nmap <D-k> <M-k>
			vmap <D-j> <M-j>
			vmap <D-k> <M-k>
		endif

	" Delete trailing white space on save, useful for Python and CoffeeScript ;)
	" 文件保存的时候，删除行末的空格
		func! DeleteTrailingWS()
		exe "normal mz"
		%s/\s\+$//ge
		exe "normal `z"
		endfunc
		autocmd BufWrite *.py :call DeleteTrailingWS()
		autocmd BufWrite *.coffee :call DeleteTrailingWS()

	"变量、函数、类、方法预览
		nnoremap <silent> <F2> :TlistToggle<CR>
		"nnoremap <silent> <F4> :TlistOpen<CR>
		"nnoremap <silent> <F12> :edit $16dig<CR>

	" => vimgrep searching and cope displaying
		" When you press gv you vimgrep after the selected text
		vnoremap <silent> gv :call VisualSelection('gv')<CR>

		" Open vimgrep and put the cursor in the right position
		map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

		" Vimgreps in the current file
		map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

		" When you press <leader>r you can search and replace the selected text
		vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

		" Do :help cope if you are unsure what cope is. It's super useful!
		"
		" When you search with vimgrep, display your results in cope by doing:
		"   <leader>cc
		"
		" To go to the next search result do:
		"   <leader>n
		"
		" To go to the previous search results do:
		"   <leader>p
		"
		map <leader>cc :botright cope<cr>
		map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
		map <leader>n :cn<cr>
		map <leader>p :cp<cr>

	" => Spell checking
		" Pressing ,ss will toggle and untoggle spell checking
		map <leader>ss :setlocal spell!<cr>

		" Shortcuts using <leader>
		map <leader>sn ]s
		map <leader>sp [s
		map <leader>sa zg
		map <leader>s? z=

	" => Misc
		" Remove the Windows ^M - when the encodings gets messed up
		noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

		" Quickly open a buffer for scripbble
		map <leader>q :e ~/buffer<cr>

		" Toggle paste mode on and off
		" 开关本地剪贴板paste模式，在非paste模式下复制代码到VIM排版会错乱，需要开启paste模式再粘贴
		map <leader>pp :setlocal paste!<cr>

	" => Helper functions
		function! CmdLine(str)
			exe "menu Foo.Bar :" . a:str
			emenu Foo.Bar
			unmenu Foo
		endfunction

		function! VisualSelection(direction) range
			let l:saved_reg = @"
			execute "normal! vgvy"

			let l:pattern = escape(@", '\\/.*$^~[]')
			let l:pattern = substitute(l:pattern, "\n$", "", "")

			if a:direction == 'b'
				execute "normal ?" . l:pattern . "^M"
			elseif a:direction == 'gv'
				call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
			elseif a:direction == 'replace'
				call CmdLine("%s" . '/'. l:pattern . '/')
			elseif a:direction == 'f'
				execute "normal /" . l:pattern . "^M"
			endif

			let @/ = l:pattern
			let @" = l:saved_reg
		endfunction

	" => HasPaste functions
		" Returns true if paste mode is enabled
		function! HasPaste()
			if &paste
				return 'PASTE MODE  '
			en
			return ''
		endfunction

	" Don't close window, when deleting a buffer
		command! Bclose call <SID>BufcloseCloseIt()
		function! <SID>BufcloseCloseIt()
		   let l:currentBufNum = bufnr("%")
		   let l:alternateBufNum = bufnr("#")

		   if buflisted(l:alternateBufNum)
			 buffer #
		   else
			 bnext
		   endif

		   if bufnr("%") == l:currentBufNum
			 new
		   endif

		   if buflisted(l:currentBufNum)
			 execute("bdelete! ".l:currentBufNum)
		   endif
		endfunction
inoremap jk <ESC>

"====================AuthorInfo插件配置====================
"====================进行版权声明的设置====================
"添加或更新头
let g:vimrc_author='yclimw'
let g:vimrc_email='limw@newlandpayment.com'
" let g:vimrc_homepage='www.yclimw.com'

nmap <F8> :AuthorInfoDetect<cr>
"================================================================================
nmap <silent> <F9> :Dash<cr>
nmap <silent> <F10> :Dash!<cr>

let g:solarized_italic=0

"===============================Syntastic Settings===============================
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" let g:syntastic_javascript_checkers=['eslint']
" let g:syntastic_javascript_eslint_execlint= 'eslint_d'
let g:syntastic_javascript_checkers=['gjslint']
let g:syntastic_java_checkers=[]

"let g:syntastic_python_checkers=['pylint']
let g:syntastic_python_checkers=[]
" let g:syntastic_python_pylint_args='--disable=C0111,R0903,C0301'
"==================================================================================
" for js
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
autocmd FileType javascript noremap <buffer>  <leader>ff :call JsBeautify()<cr>
autocmd FileType javascript vnoremap <buffer> <leader>ff :call RangeJsBeautify()<cr>
" for json 
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
autocmd FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
" for jsx 
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
autocmd FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>
