# viminit
=======
All that syntax checking, auto indent, nerdtree, fuzzy search (filename, filecontent) goodness installed as unobtrusive as possible so you can get to work without a bunch of magic happening (and without rubygems!)

Simple bash script which installs pathogen, and git clones popular repo's into bundle, and safely modify's existing vimrc, or creates a new one.

![alt tag](ss.png)

## Tested on
- debian7
- centos6
- OSX Lion/Mavericks
- Freebsd 10

## Works great with
- Python smart indentation handling (works as you expect)
- pep8 check on filesave (courtesy of https://github.com/nvie/vim-flake8)
- show pep8 errors as highlight in file, rather than in new window so main window does not lose focus
- Don't forget to install flake8: pip install flake8

## TODO:
- create backups of exists vim directory / vimrc
- only run flake8 on python filesave if flake8 exists
- javascript goodies
- ruby goodies
- go goodies

## Installation
```bash
$ curl -Lo- --insecure https://raw.github.com/jeraldrich/viminit/master/viminit.sh | bash
```
Annnnd your done. :ok_hand:

