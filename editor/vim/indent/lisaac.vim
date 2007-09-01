" Vim indent file
" Language: Lisaac
" Maintainer: Xavier Oswald <x.oswald@free.fr>
" $Date: 2007/08/21 21:33:52 $
" $Revision: 1.0 $
" URL: http://isaacproject.u-strasbg.fr/

" TODO: Improve autoindent using <CTRL-F> in Insert mode when
"       -> closing );
"       -> closing };
"       .when
"       { ... }.do_while(...);
"       lala.blbl (

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal indentexpr=GetLisaacIndent()
setlocal nolisp        " no lisp indent
setlocal nosmartindent " no start tab
setlocal nocindent     " no C indent
setlocal nosmarttab    " no start tab
setlocal expandtab     " no tabs, real spaces
setlocal autoindent    " Use indent from the previous line
setlocal tabstop=2     " tab spacing
setlocal softtabstop=2 " 2 spaces when pressing <tab> unify
setlocal shiftwidth=2  " unify

" Only define the function once.
if exists("*GetLisaacIndent")
	finish
endif

function! SkipBlanksAndComments(startline)
  let lnum = a:startline
  while lnum > 1
    let lnum = prevnonblank(lnum)
    if getline(lnum) =~ '\*/\s*$'
      while getline(lnum) !~ '/\*' && lnum > 1
        let lnum = lnum - 1
      endwhile
      if getline(lnum) =~ '^\s*/\*'
        let lnum = lnum - 1
      else
        break
      endif
    elseif getline(lnum) =~ '^\s*//'
      let lnum = lnum - 1
    else
      break
    endif
  endwhile
  return lnum
endfunction

function GetLisaacIndent()

	" Find a non-blank line above the current line.
	let lnum = prevnonblank(v:lnum - 1)

	" At the start of the file use zero indent.
	if lnum == 0
		return 0 
	endif
  
	let ind = indent(lnum)
	let line = getline(lnum)
	
	" Add a 'shiftwidth' after lines that start with a Section word
	if line =~ '^\s*Section'
		let ind = ind + &sw
		return ind 
	endif
	
	" Add a 'shiftwidth' after lines that start with an if word
	if line =~ '^\s*(.*)\.if\s*{'
		let ind = ind + &sw
		return ind 
	endif

	if line =~ '^\s*.*\.if\s*{'
		let ind = ind + &sw
		return ind 
	endif
	
	" Add a 'shiftwidth' after lines that start with an ( word
	if line =~ '^\s*('
		let ind = ind + &sw
		return ind 
	endif
	
	" Add a 'shiftwidth' after lines that start with an } else { word
	if line =~ '^\s*}\s*else\s*{'
		let ind = ind + &sw
		return ind 
	endif
	
	" Add a 'shiftwidth' after lines that start with an }.elseif { word
	if line =~ '^\s*}\.elseif\s*{'
		let ind = ind + &sw
		return ind 
	endif
	
	" Add a 'shiftwidth' after lines that start with an { }.function { word
	if line =~ '^\s*{.*}\..*\s*{'
		let ind = ind + &sw
		return ind 
	endif
	
	" Add a 'shiftwidth' after lines that start with an .when word
	if line =~ '^\s*.when.*{'
  		let ind = ind + &sw
    	return ind 
  endif
	
	" Add a 'shiftwidth' after lines that start X.[to|downto] Y do { word
	if line =~ '^\s*.*.\(to\|downto\)\s*(\=.*)\=\s*do\s*{'
		let ind = ind + &sw
		return ind 
	endif
	
	" When the line starts with a }, try aligning it with the matching {
	if getline(v:lnum) =~ '^\s*}\s*\(//.*\|/\*.*\)\=$'
		call cursor(v:lnum, 1)
		silent normal %
		let lnum = line('.')
    if lnum < v:lnum
      while lnum > 1
        let next_lnum = SkipBlanksAndComments(lnum - 1)
				if getline(next_lnum) !~ ',\s*$'
          break
        endif
        let lnum = prevnonblank(next_lnum)
      endwhile
      return indent(lnum)
    endif
		return ind 
  endif
	
return ind

endfunction	
" vim:sw=2
