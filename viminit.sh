#!/bin/bash

vim_dir=$HOME"/.vim"
pathogen_file=$HOME"/.vim/autoload/pathogen.vim"
vim_rc=$HOME"/.vimrc"
vim_info=$HOME"/.viminfo"

# make sure git is installed
if ! which git > /dev/null; then
  echo 'git must be installed.'
  exit 0
fi

# ask user if they want to fresh install
read -p "Remove existing vim config and plugins (y,n)? " choice
case "$choice" in
  y|Y )
      if [ -d $vim_dir ]; then rm -rf $vim_dir && echo $vim_dir" removed"; fi
      if [ -f $vim_rc ]; then rm $vim_rc && echo $vim_rc" removed"; fi
      if [ -f "$vim_info" ]; then rm $vim_info && echo $vim_info" removed"; fi ;;
  * ) echo "preserving existing vim config and plugins." ;;
esac

# create vim dir if not exists
if [ ! -d $vim_dir ];
then
  mkdir ~/.vim
fi

# install pathogen
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/colors
if [ ! -e $pathogen_file ];
then
  echo 'Installing pathogen...'
  curl -Lo- --insecure https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim > $pathogen_file
else
  echo 'Pathogen already installed.'
fi

function modify_vimrc()
{
  if [ ! -f $vim_rc ];
  then
    touch $vim_rc
  fi
  if ! grep -qFx "$1" $vim_rc;
  then
    # creating a tmp file is necessary in order to prepend to .vimrc
    # without using sed or ed, which both function differently between 
    # linux / osx 
    tmp_file='viminal.tmp'
    if [ "$2" == "prepend" ];
    then
      echo "prepending "$1" to .vimrc"
      echo "$1" > $tmp_file
      cat $vim_rc >> $tmp_file
      mv $tmp_file $vim_rc
    else
      echo "appending "$1" to .vimrc"
      echo "$1" > $tmp_file
      cat $tmp_file >> $vim_rc
      rm $tmp_file
    fi
  fi
}

# change default \ to ,
modify_vimrc 'let mapleader = ","'
# modify vimrc to run pathogen on vim startup
modify_vimrc "execute pathogen#infect()" "prepend"
# enable additional plugins
modify_vimrc "filetype plugin on"
# always indent using spaces
modify_vimrc "filetype plugin indent on"
# show existing tab with 4 spaces width
modify_vimrc "set tabstop=4"
# preserve undo marks and buffers while buffer is open on existing file when opening new file
modify_vimrc "set hidden"
# when indenting with '>', use 4 spaces width
modify_vimrc "set shiftwidth=4"
# On pressing tab, insert 4 spaces
modify_vimrc "set expandtab"
# expands tabs to number of spaces
modify_vimrc "set smarttab"
# set sensible .vimrc settings like set number, show match ect
modify_vimrc "syntax on"
# always show line numbers
modify_vimrc "set number"
# highlight search terms
modify_vimrc "set hlsearch"
# show search matches as you type"
modify_vimrc "set incsearch"
# show matching parenthesis
modify_vimrc "set showmatch"
# autoindent on newlines
modify_vimrc "set autoindent"
# ignore case if search pattern is all lowercase
modify_vimrc "set smartcase"
# change terminal title
modify_vimrc "set title"
# remember more commands and search history
modify_vimrc "set history=1000"
# remember more undos
modify_vimrc "set undolevels=1000"
# don't beep
modify_vimrc "set visualbell"
modify_vimrc "set noerrorbells"
# enable vim og no backups, swaps, or save points
modify_vimrc "set nobackup" 
modify_vimrc "set noswapfile"
# if your code can't fit in 79 columns, python may not be for you
modify_vimrc "set nowrap"
# set ignore files
modify_vimrc "set wildmode=list:longest,list:full"
modify_vimrc "set wildignore+=*.o,*.obj,.git,*.rbc,*.swp,*.class,.svn"
# NERDTree configuration
modify_vimrc "let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$', '__pycache__']"
modify_vimrc "map n :NERDTreeToggle<CR>"
# Easygrep config
modify_vimrc "let g:EasyGrepRecursive = 1"
modify_vimrc "let g:EasyGrepFilesToExclude = '*.pyc,*.rbc'"
# use non-utf8 nerdtree arrows so utf-8 is not required and doesnt display weird symbols
modify_vimrc "let g:NERDTreeDirArrows=0"
modify_vimrc "set t_Co=256"
# show whitespace chars as grey lines
modify_vimrc "autocmd filetype python set list listchars=tab:\\|\\" 
# pep8 width, smartindents
modify_vimrc "au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79"
# new line after methods, class ect in python (very annoying if not set)
modify_vimrc "autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class"
# run flake8 on every python filesave, with markers on pep8 error
modify_vimrc "autocmd BufWritePost *.py call Flake8()"
# just highlight pep8 errors in file, rather than create new window (annoying)
modify_vimrc  "let g:flake8_show_quickfix=0"
modify_vimrc  "let g:flake8_show_in_file=1"
# identify hidden tab vermin
modify_vimrc "set list"
modify_vimrc "set listchars=tab:>.,trail:.,extends:#,nbsp:."
# enable ability to press f2 and paste what was copied without smart indent / styling
modify_vimrc "set pastetoggle=<F2>"
# clear search buffer highlight when pressing ,c instead of :nohlsearch
modify_vimrc "nnoremap <leader>c :nohl<CR>"
# map redo to shift r
modify_vimrc "nnoremap <S-r> <c-r>"
# map escape from insert mode to jk
modify_vimrc "inoremap jk <Esc>"


# smart next line indention detection
mkdir -p ~/.vim/indent
python_indent_file=$HOME"/.vim/indent/python.vim"
if [ ! -e $python_indent_file ];
then 
  echo 'Installing Python indent...'
  curl "https://vim.sourceforge.io/scripts/download_script.php?src_id=4316" \
        > $HOME"/.vim/indent/python.vim"
else
  echo 'Python indent already installed.'
fi

## install pathogen plugins ##
bundle_dir=$HOME"/.vim/bundle"
if [ ! -d $bundle_dir ];
then
  echo $bundle_dir" does not exist. Pathogen has failed to install!"
  exit 0
fi

# install NERDTree
nerdtree_dir=$HOME"/.vim/bundle/nerdtree"
if [ ! -d $nerdtree_dir ];
then
  echo "Installing NERDTree..."
  git clone https://github.com/scrooloose/nerdtree.git $nerdtree_dir
else
  echo "NERDTree already installed."
fi

# install NERDcommenter. Makes mass comment changes much easier
nerdcommenter_dir=$HOME"/.vim/bundle/nerdcommenter_dir"
if [ ! -d $nerdcommenter_dir ];
then
  echo "Installing NERDcommenter..."
  git clone https://github.com/scrooloose/nerdcommenter.git $nerdcommenter_dir
else
  echo "NERDcommenter already installed."
fi

# install vim-surround
vimsurround_dir=$HOME"/.vim/bundle/vim-surround"
if [ ! -d $vimsurround_dir ];
then
  echo "Installing vim-surround..."
  git clone git://github.com/tpope/vim-surround.git $vimsurround_dir
else
  echo "vim-surround already installed."
fi

# install delimitMate (autoclose brackets, quotes, ect)
delimitMate_dir=$HOME"/.vim/bundle/delimitMate"
if [ ! -d $delimitMate_dir ];
then
  echo "Installing delimitMate..."
  git clone git://github.com/Raimondi/delimitMate.git $delimitMate_dir
else
  echo "delimitMate already installed."
fi

# install ctrlp
ctrlp_dir=$HOME"/.vim/bundle/ctrlp"
if [ ! -d $ctrlp_dir ];
then
  echo "Installing ctrlp..."
  git clone https://github.com/kien/ctrlp.vim.git $ctrlp_dir
else
  echo "ctrlp already installed."
fi

# install vim-flake8
vimflake8_dir=$HOME"/.vim/bundle/vim-flake8"
if [ ! -d $vimflake8_dir ];
then
  echo "Installing flake8..."
  git clone https://github.com/nvie/vim-flake8.git $vimflake8_dir
else
  echo "flake8 already installed."
fi

# coffeescript syntax highlighter, compile js tester
coffee_dir=$HOME"/.vim/bundle/vim-coffee-script"
if [ ! -d $coffee_dir ];
then 
  echo "Installing vim-coffeescript..."
  git clone https://github.com/kchmck/vim-coffee-script.git $coffee_dir
else
  echo 'vim-coffeescript already installed.'
fi

# ag fuzzy full project filename and content search faster than ack or grep
ag_dir=$HOME"/.vim/bundle/ag"
if [ ! -d $ag_dir ];
then 
  echo 'Installing ag...'
  git clone https://github.com/rking/ag.vim $ag_dir
else
  echo 'ag already installed.'
fi

# mustang theme
mkdir -p ~/.vim/colors
mustang_file=$HOME"/.vim/colors/mustang.vim"
if [ ! -e $mustang_file ];
then 
  echo 'Installing mustang theme...'
  curl -Lo- --insecure https://raw.githubusercontent.com/jeraldrich/mustang-vim/master/colors/mustang.vim > $mustang_file
else
  echo 'mustang theme already installed.'
fi

modify_vimrc "let g:rehash256 = 1"
modify_vimrc "colorscheme mustang"
