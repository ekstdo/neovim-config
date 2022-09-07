au BufNewFile,BufRead *.md exec "source " . fnamemodify(expand("$MYVIMRC"), ":h") . "/onMarkdown.vim"
