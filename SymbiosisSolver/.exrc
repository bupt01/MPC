if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
inoremap <F8> 
imap <C-F7> <F3>:<C-F7>
imap <F7> <F7>
imap <F6> <F3>:!ctags -R
imap <F5> <F3>:!./run.bat
imap <F4> :WMToggle
imap <F3> :w!
imap <F2> :e%
map  :buffers
map  :bp
map  :bn
vnoremap <silent> # :let old_reg=getreg('"')|let old_regtype=getregtype('"')gvy?=substitute(escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')gV:call setreg('"', old_reg, old_regtype)
vnoremap <silent> * :let old_reg=getreg('"')|let old_regtype=getregtype('"')gvy/=substitute(escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')gV:call setreg('"', old_reg, old_regtype)
nmap \ig :IndentGuidesToggle
nmap \caL <Plug>CalendarH
nmap \cal <Plug>CalendarV
map cc ^i//
map cp ^i# 
nmap gx <Plug>NetrwBrowseX
map hc ^i#include <iostream>^iusing namespace std;^i^iint main()^i{^i	return 0;^i}
map hy ^i#!/usr/bin/env python^i# coding: utf-8^i  ^ifrom util import *^i^iif __name__ == "__main__":
map ucc ^i<Del><Del>
map ucp ^i<Del>
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
nnoremap <silent> <Plug>CalendarH :cal Calendar(1)
nnoremap <silent> <Plug>CalendarV :cal Calendar(0)
map <S-F9> :set wrap
map <F9> :set nowrap
map <C-F7> <F3>:!make clean; clear; make
map <F7> <F3>:!clear && make
map <F6> <F3>:!ctags -R
map <F5> <F3>:!./run.bat
map <F4> :WMToggle
map <F3> :w!
map <F2> :e%
imap  
imap  
imap  
let &cpo=s:cpo_save
unlet s:cpo_save
set autoindent
set background=dark
set backspace=indent,eol,start
set cindent
set expandtab
set fileencodings=utf8,cp936
set helplang=en
set history=1000
set hlsearch
set ignorecase
set incsearch
set mouse=a
set printoptions=paper:letter
set ruler
set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim74,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after
set selection=exclusive
set selectmode=mouse,key
set shiftwidth=4
set showmatch
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tabstop=4
set tags=tags;/
set termencoding=utf-8
set visualbell
" vim: set ft=vim :
