au BufNewFile,BufRead,VimEnter  *.md exec "source " . fnamemodify(expand("$MYVIMRC"), ":h") . "/markdown/initmarkdown.vim"
