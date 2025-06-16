set number
" 启用相对行号
" set relativenumber
" 启用语法高亮
syntax on
" 设置未保存可以缓冲暂存文件跳转
set hidden
" 设置
set noswapfile
" 启用文件类型检测
filetype plugin indent on
" 设置Tab键为4个空格
set noexpandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4
set softtabstop=4
" 设置vim响应时间为66ms
set updatetime=66
" 设置文件编码
set encoding=utf-8
" 合并行号和相对行号
set signcolumn=number
" 启用自动缩进
set autoindent
" 启用智能缩进
set smartindent
" 启用搜索高亮
set hlsearch
set incsearch
" 显示匹配的括号
set showmatch
" 启用鼠标支持
" set mouse=a
" 在分屏之间切换时显示光标行号
set cursorline
" 设置backspace可以直接删除缩进/行首/行尾
set backspace=indent,eol,start
" 同步系统剪切板
set clipboard=unnamed
" 启用调试信息
"set verbose=0

let g:mapleader = " "
"注释配置
"let g:NERDCommentMapLeader = 'C-/'
" 插件调用
call plug#begin('~/.vim/plugged')

" Plug 'SirVer/ultisnips' " 代码小片段
Plug 'tpope/vim-surround'
Plug 'vim-scripts/ReplaceWithRegister'
" Plug 'preservim/nerdtree'
Plug 'christoomey/vim-system-copy'
Plug 'tikhomirov/vim-glsl' "glsl语言高亮扩展
Plug 'tpope/vim-fugitive' " git插件
Plug 'jiangmiao/auto-pairs' "自动配对括号类
Plug 'neoclide/coc.nvim', {'branch': 'release'} "coc插件本体
Plug 'altercation/vim-colors-solarized'
Plug 'weirongxu/coc-explorer' "文件管理
Plug 'rhysd/vim-clang-format'
Plug 'vim-scripts/cmake'
Plug 'wakatime/vim-wakatime'
Plug 'frazrepo/vim-rainbow' "彩虹括号
Plug 'vim-airline/vim-airline' "状态栏美化
Plug 'vim-airline/vim-airline-themes' "状态栏美化主题
Plug 'yggdroot/indentline' "代码缩进线条
Plug 'mhinz/vim-startify' "vim开始界面
Plug 'itchyny/vim-cursorword' "光标单词下划线
Plug 'preservim/nerdcommenter' "注释代码
Plug 'critiqjo/lldb.nvim' "lldb调试
Plug 'morhetz/gruvbox' " Gruvbox 主题

call plug#end()

" --- 主题设置 ---

" 1. Gruvbox 设置
" colorscheme gruvbox                    " 设置主题为 gruvbox
" colorscheme desert 
" colorscheme solarized
set background=dark " 设置背景为深色模式，可选值：dark 或 light
"let g:gruvbox_contrast_dark='medium'   " 深色模式下的对比度，可选值：soft, medium, hard
"let g:gruvbox_contrast_light='soft'    " 浅色模式下的对比度，可选值：soft, medium, hard

" 2. Solarized 设置
"colorscheme solarized                    " 设置主题为 solarized
"set background=dark                      " 设置背景为深色模式，可选值：dark 或 light
"let g:solarized_termcolors=256           " 启用 256 色模式

" 3. One Dark 设置
"colorscheme onedark                      " 设置主题为 onedark
"let g:onedark_terminal_italics=1         " 启用终端斜体字支持
" 配置背景透明
"let g:onedark_transparent_background = 1

" 设置不同风格（对比度）
"let g:onedark_style = 'darker'        " 可选值：normal, darker, warm

" 4. Nord 设置
"colorscheme nord                         " 设置主题为 nord
"let g:nord_contrast = 1 " 启用对比度设置
"let g:nord_borders = 1                " 显示边框

" 6. PaperColor 设置
"colorscheme PaperColor                   " 设置主题为 PaperColor
"set background=dark " 设置背景为浅色模式，可选值：light 或 dark

" 7. Dracula 设置
"colorscheme dracula                      " 设置主题为 dracula
"let g:dracula_colorterm = 0              " 关闭终端中的颜色支持

" 8. Everforest 设置
"colorscheme everforest                   " 设置主题为 everforest
"set background=dark                      " 设置背景为深色模式
"let g:airline_theme = 'everforest'

" 9. Monokai 设置
"colorscheme monokai                      " 设置主题为 monokai
"

" 禁用方向键
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

noremap <C-q> :wq<CR>
" 关闭高亮
nnoremap nh :noh<CR>
"编辑snippets
noremap <C-p> :CocCommand snippets.editSnippets<CR>
" 大写快速上下五行
noremap <silent> K 5k
noremap <silent> J 5j
"防止粘贴替换寄存器内容
vmap p "_dp
"行首行尾跳转
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
" Use <C-j> for select text for visual placeholder of snippet.
vnoremap <C-j> <Plug>(coc-snippets-select)
" Use <C-j> for both expand and jump (make expand higher priority.)
inoremap <C-j> <Plug>(coc-snippets-expand-jump)

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-J>'
" let g:coc_snippet_next = '<tab>'
" 设置coc补全配置
" 设置tab键补全
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
" 设置shift+tab向上补全
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" 设置回车确认补全
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" 退格按键
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" ctrl-o召唤补全
inoremap <silent><expr> <c-o> coc#refresh()
" 设置向上查找代码报错点-
nmap <silent> - <Plug>(coc-diagnostic-prev)
" 设置向下查找代码报错点+
nmap <silent> = <Plug>(coc-diagnostic-next)
" 查找此函数定义点
nmap <silent> gd <Plug>(coc-definition)
" 查找此类型定义点
nmap <silent> gy <Plug>(coc-type-definition)
" 查找实现
nmap <silent> gi <Plug>(coc-implementation)
" 查找参考
nmap <silent> gr <Plug>(coc-references)
" 显示文档
nnoremap <silent> <LEADER>h :call <SID>show_documentation()<CR>
" 显示文档函数
function! s:show_documentation()
    if(index(['vim','help'], &filetype)>=0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction
" 重命名变量或函数
nmap <LEADER>rn <Plug>(coc-rename)
" 绑定 F3 打开 文件浏览器
noremap <F3> :CocCommand explorer <CR>
noremap H ^
noremap L $
" ctrl+w+t新标签页打开终端
" nnoremap <C-w>t :call OpenTermInNewTab()<CR>
function! OpenTermInNewTab()
  tabnew | term
endfunction
nnoremap q ge
nnoremap <C-s> :w<CR>
vnoremap <C-s> <ESC>:w<CR>
inoremap <C-s> <ESC>:w<CR>l
" tt当前页面分出一个终端
nnoremap tt :term<CR>
nnoremap <C-w>j gt
nnoremap <C-w><C-j> gt
nnoremap <C-w>k gT
nnoremap <C-w><C-k> gT
noremap <C-w><C-c> <C-w>c
" 切换模式映射
inoremap jk <ESC>
nnoremap <C-j> i
vnoremap <C-k> <ESC>
" Leader+i 进入命令输入模式并显示输入
nnoremap <Leader>i :call InsertTextAtCursor()<CR>
" 定义 InsertTextAtCursor 函数
function! InsertTextAtCursor()
  " 获取用户输入
  let user_input = input('insert text: ')
  " 将用户输入插入到光标处
  execute 'normal! i' . user_input
endfunction

"vim插件加载
let g:coc_global_extensions = [
	\ 'coc-css',
	\ 'coc-clangd',
	\ 'coc-cmake',
	\ 'coc-diagnostic',
	\ 'coc-docker',
	\ 'coc-eslint',
	\ 'coc-explorer',
	\ 'coc-flutter-tools',
	\ 'coc-gitignore',
	\ 'coc-html',
	\ 'coc-import-cost',
	\ 'coc-java',
	\ 'coc-jest',
	\ 'coc-json',
	\ 'coc-lists',
	\ 'coc-omnisharp',
	\ 'coc-prisma',
	\ 'coc-pyright',
	\ 'coc-snippets',
	\ 'coc-sourcekit',
	\ 'coc-stylelint',
	\ 'coc-syntax',
	\ 'coc-tasks',
	\ 'coc-vimlsp',
	\ 'coc-yaml',
	\ 'coc-yank',
	\ 'coc-sonarlint',
	\ 'coc-prettier']
