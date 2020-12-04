augroup rust_bindings
  au!
  au BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo
  au FileType rust nmap <silent> <leader>r :make run<CR>
  au FileType rust nmap <silent> <leader>t :make test<CR>
  au FileType rust nmap <silent> <leader>b :make check<CR>
  au FileType rust nmap <leader>d <Plug>(rust-doc)
  au FileType rust nmap gd <Plug>(rust-def)

  au QuickFixCmdPost [^l]* nested cwindow
  au QuickFixCmdPost    l* nested lwindow
augroup END

let g:syntastic_rust_checkers = []
let g:rust_conceal = 1
let g:rustfmt_autosave = 1
let g:racer_experimental_completer = 1
