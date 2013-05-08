# install pathogen
mkdir -p "~/.vim/autoload ~/.vim/bundle"
pathogen_file=$HOME"/.vim/autoload/pathogen.vim"
if [ ! -e $pathogen_file ];
then 
  echo 'installing pathogen'
  curl "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim" \
        > $HOME"/.vim/autoload/pathogen.vim"
else
  echo 'pathogen already installed'
fi

# modify vimrc to run pathogen on vim startup
vimrc_file=$HOME"/.vimrc"
if [ ! -f $vimrc_file ];
then
  touch $vimrc_file
fi
if ! grep -qx 'execute pathogen#infect()' $vimrc_file;
then
  # creating a tmp file is necessary in order to prepend to .vimrc
  # without using sed or ed, which both function differently between 
  # linux / osx 
  tmp_file='viminal.tmp'
  echo 'appending pathogen#infect() to .vimrc'
  echo 'execute pathogen#infect()' > $tmp_file 
  cat $vimrc_file >> $tmp_file
  mv $tmp_file $vimrc_file
fi
