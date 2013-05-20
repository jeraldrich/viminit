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
  if ! grep -qx "$1" $vimrc_file;
  then
    # creating a tmp file is necessary in order to prepend to .vimrc
    # without using sed or ed, which both function differently between 
    # linux / osx 
    tmp_file='viminal.tmp'
    echo 'prepending '$1' to .vimrc'
    echo "$1" > $tmp_file
    cat $vimrc_file >> $tmp_file
    mv $tmp_file $vimrc_file
  fi
}
# set sensible .vimrc settings like set number, show match ect
modify_vimrc "syntax on" 
modify_vimrc "set number"
modify_vimrc "set showmatch"
# start nerdtree and reset focus from nerdtree to open file
modify_vimrc 'autocmd VimEnter * wincmd l'
modify_vimrc 'autocmd VimEnter * NERDTree'
# use git for backups.. 
modify_vimrc "set nobackup"
modify_vimrc "set noswapfile"
# modify vimrc to run pathogen on vim startup
modify_vimrc "execute pathogen#infect()"

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

# install ack.vim
ackvim_dir=$HOME"/.vim/bundle/ack.vim"
if [ ! -d $ackvim_dir ];
then
  if ! which ack > /dev/null; then
    echo 'Unable to install the ack.vim plugin. ack must be installed. see this page for more info https://github.com/mileszs/ack.vim'
  else
    echo $ackvim_dir" does not exist. Installing..."
    git clone https://github.com/mileszs/ack.vim.git $ackvim_dir
  fi
else
  echo $ackvim_dir" already exists."
fi
