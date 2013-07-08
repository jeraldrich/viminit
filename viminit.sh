# make sure .vim directory exists
vim_dir=$HOME"/.vim"
if [ ! -d $vim_dir ];
then
  echo $vim_dir" does not exist. Creating .vim directory..."
  mkdir ~/.vim
fi
# make sure git is installed
if ! which git > /dev/null; then
  echo 'git must be installed. git with it.'
  exit 0
fi

# install pathogen
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle
pathogen_file=$HOME"/.vim/autoload/pathogen.vim"
if [ ! -e $pathogen_file ];
then 
  echo 'installing pathogen'
  curl "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim" \
        > $HOME"/.vim/autoload/pathogen.vim"
else
  echo 'Pathogen already installed'
fi

function modify_vimrc() 
{
  vimrc_file=$HOME"/.vimrc"
  if [ ! -f $vimrc_file ];
  then
    touch $vimrc_file
  fi
  if ! grep -qFx "$1" $vimrc_file;
  then
    # creating a tmp file is necessary in order to prepend to .vimrc
    # without using sed or ed, which both function differently between 
    # linux / osx 
    tmp_file='viminal.tmp'
    if [ "$2" == "prepend" ];
    then
      echo "prepending "$1" to .vimrc"
      echo "$1" > $tmp_file
      cat $vimrc_file >> $tmp_file
      mv $tmp_file $vimrc_file
    else
      echo "appending "$1" to .vimrc"
      echo "$1" > $tmp_file
      cat $tmp_file >> $vimrc_file
      rm $tmp_file
    fi
  fi
}
# modify vimrc to run pathogen on vim startup
modify_vimrc "execute pathogen#infect()" "prepend"
# start nerdtree and reset focus from nerdtree to open file
modify_vimrc 'autocmd VimEnter * NERDTree'
modify_vimrc 'autocmd VimEnter * wincmd l'
# expand tab if python file
modify_vimrc 'autocmd filetype python set expandtab'
# smartindent if python. example if True: <enter> new line will be tab by tabstop num
modify_vimrc 'autocmd filetype python set smartindent'
# python pep8 width
modify_vimrc 'au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79'
# set sensible .vimrc settings like set number, show match ect
modify_vimrc "syntax on" 
# show whitespace
modify_vimrc "set list listchars=tab:\ \ ,trail:·"
# always show line numbers
modify_vimrc "set number"
# four-space tab indent
modify_vimrc "set tabstop=4"
# shift < > keys to 4
modify_vimrc "set shiftwidth=4"
# insert tabs on the start of a line according to shiftwidth not tabstop
modify_vimrc "set smarttab"
# highlight search terms
modify_vimrc "set hlsearch"
# show search matches as you type"
modify_vimrc "set incsearch"
# show matching parenthesis
modify_vimrc "set showmatch"
modify_vimrc "filetype plugin on"
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
# use git for backups.. 
modify_vimrc "set nobackup"
modify_vimrc "set noswapfile"
# set ignore files
modify_vimrc "set wildmode=list:longest,list:full"
modify_vimrc "set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*"
# NERDTree configuration
modify_vimrc "let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']"
modify_vimrc "map <Leader>n :NERDTreeTabsToggle<CR>"

## create indent dir and indent files 
# these are used to set indent settings per filetype 
mkdir -p ~/.vim/indent
python_indent_file=$HOME"/.vim/indent/python.vim"
if [ ! -e $python_indent_file ];
then 
  echo 'Installing Python indent file'
  curl "http://www.vim.org/scripts/download_script.php?src_id=4316" \
        > $HOME"/.vim/indent/python.vim"
else
  echo 'Python indent file already installed'
fi

## install plugins ##

bundle_dir=$HOME"/.vim/bundle"
if [ ! -d $bundle_dir ];
then
  echo $bundle_dir" does not exist. Pathogen has failed to install."
  exit 0
fi

# install NERDTree
nerdtree_dir=$HOME"/.vim/bundle/nerdtree"
if [ ! -d $nerdtree_dir ];
then
  echo $nerdtree_dir" does not exist. Installing..."
  git clone https://github.com/scrooloose/nerdtree.git $nerdtree_dir
else
  echo $nerdtree_dir" already exists."
fi

# install NERDTree tabs. Generally makes nerdtree function better
nerdtree_tabs_dir=$HOME"/.vim/bundle/nerdtree_tabs"
if [ ! -d $nerdtree_tabs_dir ];
then
  echo $nerdtree_tabs_dir" does not exist. Installing..."
  git clone https://github.com/jistr/vim-nerdtree-tabs.git $nerdtree_tabs_dir
else
  echo $nerdtree_tabs_dir" already exists."
fi

# install NERDcommenter. Makes mass comment changes much easier
nerdcommenter_dir=$HOME"/.vim/bundle/nerdcommenter_dir"
if [ ! -d $nerdcommenter_dir ];
then
  echo $nerdcommenter_dir" does not exist. Installing..."
  git clone https://github.com/scrooloose/nerdcommenter.git $nerdcommenter_dir
else
  echo $nerdcommenter_dir" already exists."
fi

# install vim-surround
vimsurround_dir=$HOME"/.vim/bundle/vim-surround"
if [ ! -d $vimsurround_dir ];
then
  echo $vimsurround_dir" does not exist. Installing..."
  git clone git://github.com/tpope/vim-surround.git $vimsurround_dir
else
  echo $vimsurround_dir" already exists."
fi

# install delimitMate
delimitMate_dir=$HOME"/.vim/bundle/delimitMate"
if [ ! -d $delimitMate_dir ];
then
  echo $delimitMate_dir" does not exist. Installing..."
  git clone git://github.com/Raimondi/delimitMate.git $delimitMate_dir
else
  echo $delimitMate_dir" already exists."
fi

# install ctrlp
ctrlp_dir=$HOME"/.vim/bundle/ctrlp"
if [ ! -d $ctrlp_dir ];
then
  echo $ctrlp_dir" does not exist. Installing..."
  git clone https://github.com/kien/ctrlp.vim.git $ctrlp_dir
else
  echo $ctrlp_dir" already exists."
fi

# install easygrep
easygrep_dir=$HOME"/.vim/bundle/easygrep"
if [ ! -d $easygrep_dir ];
then
  echo $easygrep_dir" does not exist. Installing..."
  git clone https://github.com/vim-scripts/EasyGrep $easygrep_dir
else
  echo $easygrep_dir" already exists."
fi

