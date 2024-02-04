" Cheockout https://github.com/sbdchd/neoformat for more info
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

" Specific formatters, other than the defaults
let g:neoformat_enabled_nix = ['alejandra']
let g:neoformat_enabled_c# = []

