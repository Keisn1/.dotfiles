inoremap fd <ESC>
vnoremap fd <ESC>
set timeoutlen=150
set tabstop=4

xnoremap "+y y:call system("wl-copy", @")<cr>
nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
