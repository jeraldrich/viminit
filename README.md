# viminit
=======
viminit! when you just want all that syntax checking, auto indent, nerdtree, fuzzy search goodness installed on any environment in one command

![alt tag](ss.png)
![alt tag](ss2.png)

## Tested on
- debian7
- centos6
- OSX Lion/Mavericks
- Freebsd 10

## Works great with
- Python auto indentation, pep8 check on filesave, whitespace indicator (courtesy of https://github.com/nvie/vim-flake8)
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

BAM! Done. No babysitting rubygems. It's not going to win any code artshows, but it gets the job done.

