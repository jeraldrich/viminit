# make sure .vim directory exists
vim_dir=$HOME"/.vim"
if [ ! -d $vim_dir ];
then
  echo $vim_dir" does not exist. Please install VIM before installing Viminal."
  exit 0
fi
# make sure git is installed
if ! which git > /dev/null; then
  echo 'git must be installed. git with it.'
  exit 0
fi

# install pathogen
mkdir -p "~/.vim/autoload ~/.vim/bundle"
pathogen_file=$HOME"/.vim/autoload/pathogen.vim"
if [ ! -e $pathogen_file ];
then 
  echo 'installing pathogen'
  curl "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim" \
        > $HOME"/.vim/autoload/pathogen.vim"
else
  echo 'Pathogen already installed'
fi

# modify vimrc to run pathogen on vim startup
vimrc_file=$HOME"/.vimrc"
if [ ! -f $vimrc_file ];
then
  touch $vimrc_file
fi
if ! grep -qx 'execute pathogen#infect()' $vimrc_file;
then
  echo 'Inserting pathogen into ~/.vimrc file...'
  # creating a tmp file is necessary in order to prepend to .vimrc
  # without using sed or ed, which both function differently between 
  # linux / osx 
  tmp_file='viminal.tmp'
  echo 'appending pathogen#infect() to .vimrc'
  echo 'execute pathogen#infect()' > $tmp_file 
  cat $vimrc_file >> $tmp_file
  mv $tmp_file $vimrc_file
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
fi

# install nerdtree-ack
nerdtreeack_dir=$HOME"/.vim/bundle/nerdtree-ack"
if [ ! -d $nerdtreeack_dir ];
then
  if ! which ack > /dev/null; then
    echo 'Unable to install the nerdtree-ack.vim plugin. ack must be installed. see this page for more info https://github.com/mileszs/ack.vim'
  else
    echo $nerdtreeack_dir" does not exist. Installing..."
    git clone git://github.com/tyok/nerdtree-ack.git $nerdtreeack_dir
  fi
fi
