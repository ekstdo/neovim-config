au BufNewFile,BufRead *.md exec "source " . fnamemodify(expand("$MYVIMRC"), ":h") . "/markdown/initmarkdown.vim"

ab nl \\
ab np \%
ab !> \mapsto
