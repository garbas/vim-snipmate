" File:          snipMate.vim
" Author:        Michael Sanders
" Version:       0.84
" Description:   snipMate.vim implements some of TextMate's snippets features in
"                Vim. A snippet is a piece of often-typed text that you can
"                insert into your document using a trigger word followed by a "<tab>".
"
"                For more help see snipMate.txt; you can do this by using:
"                :helptags ~/.vim/doc
"                :h snipMate.txt

if exists('loaded_snips') || &cp || version < 700
	finish
endif
let loaded_snips = 1
if !exists('snips_author') | let snips_author = 'Me' | endif

if (!exists('g:snipMateSources'))
  let g:snipMateSources = {}
  " default source: get snippets based on runtimepath:
  let g:snipMateSources['default'] = funcref#Function('snipMate#DefaultPool')
endif

au BufRead,BufNewFile *.snippets\= set ft=snippet
au FileType snippet setl noet fdm=expr fde=getline(v:lnum)!~'^\\t\\\\|^$'?'>1':1

" config which can be overridden (shared lines)
if !exists('g:snipMate')
  let g:snipMate = {}
endif
let s:snipMate = g:snipMate

let s:snipMate['get_snippets'] = get(s:snipMate, 'get_snippets', funcref#Function("snipMate#GetSnippets"))

" old snippets_dir: function returning list of paths which is used to read
" snippets. You can replace it with your own implementation. Defaults to all
" directories in &rtp/snippets/*
let s:snipMate['snippet_dirs'] = get(s:snipMate, 'snippets_dirs', funcref#Function('return split(&runtimepath,",")'))

" _ is default scope added always
"
" &ft honors multiple filetypes and syntax such as in set ft=html.javascript syntax=FOO
let s:snipMate['get_scopes'] = get(s:snipMate, 'get_scopes', funcref#Function('return split(&ft,"\\.")+[&syntax, "_"]'))

if !exists('snippets_dir')
	let snippets_dir = substitute(globpath(&rtp, 'snippets/'), "\n", ',', 'g')
endif

" Processes a single-snippet file; optionally add the name of the parent
" directory for a snippet with multiple matches.
fun! s:ProcessFile(file, ft, ...)
	let keyword = fnamemodify(a:file, ':t:r')
	if keyword  == '' | return | endif
	try
		let text = join(readfile(a:file), "\n")
	catch /E484/
		echom "Error in snipMate.vim: couldn't read file: ".a:file
	endtry
	return a:0 ? MakeSnip(a:ft, a:1, text, keyword)
			\  : MakeSnip(a:ft, keyword, text)
endf

fun! TriggerSnippet()
	if exists('g:SuperTabMappingForward')
		if g:SuperTabMappingForward == "<tab>"
			let SuperTabPlug = maparg('<Plug>SuperTabForward', 'i')
			if SuperTabPlug == ""
				let SuperTabKey = "\<c-n>"
			else
				exec "let SuperTabKey = \"" . escape(SuperTabPlug, '<') . "\""
			endif
		elseif g:SuperTabMappingBackward == "<tab>"
			let SuperTabPlug = maparg('<Plug>SuperTabBackward', 'i')
			if SuperTabPlug == ""
				let SuperTabKey = "\<c-p>"
			else
				exec "let SuperTabKey = \"" . escape(SuperTabPlug, '<') . "\""
			endif
		endif
	endif

	if pumvisible() " Update snippet if completion is used, or deal with supertab
		if exists('SuperTabKey')
			call feedkeys(SuperTabKey) | return ''
		endif
		call feedkeys("\<esc>a", 'n') " Close completion menu
		call feedkeys("\<tab>") | return ''
	endif

	if exists('g:snipPos') | return snipMate#jumpTabStop(0) | endif

	let word = matchstr(getline('.'), '\S\+\%'.col('.').'c')
	let [trigger, snippet] = s:GetSnippet(word)
	" If word is a trigger for a snippet, delete the trigger & expand
	" the snippet.
	if snippet != ''
		let &undolevels = &undolevels " create new undo point
		let col = col('.') - len(trigger)
		sil exe 's/\V'.escape(trigger, '/\.').'\%#//'
		return snipMate#expandSnip(snippet, col)
	endif

	if exists('SuperTabKey')
		call feedkeys(SuperTabKey)
		return ''
	endif
	return word == ''
	  \ ? "\<tab>"
	  \ : "\<c-r>=ShowAvailableSnips()\<cr>"
endf

fun! BackwardsSnippet()
	if exists('g:snipPos') | return snipMate#jumpTabStop(1) | endif

	if exists('g:SuperTabMappingForward')
		if g:SuperTabMappingForward == "<s-tab>"
			let SuperTabPlug = maparg('<Plug>SuperTabForward', 'i')
			if SuperTabPlug == ""
				let SuperTabKey = "\<c-n>"
			else
				exec "let SuperTabKey = \"" . escape(SuperTabPlug, '<') . "\""
			endif
		elseif g:SuperTabMappingBackward == "<s-tab>"
			let SuperTabPlug = maparg('<Plug>SuperTabBackward', 'i')
			if SuperTabPlug == ""
				let SuperTabKey = "\<c-p>"
			else
				exec "let SuperTabKey = \"" . escape(SuperTabPlug, '<') . "\""
			endif
		endif
	endif
	if exists('SuperTabKey')
		call feedkeys(SuperTabKey)
		return ''
	endif
	return "\<s-tab>"
endf

" Check if the word under the cursor is a snippet trigger.
" If it is not, it gets split by non-word characters and looked up in
" parts, e.g. 'foo' in 'bar.foo'.
fun! s:GetSnippet(word)
	let snippet = ''
	let lookups = [a:word] " lookup whole word always and first, e.g. '$_'
	let parts = split(a:word, '\W\zs')
	if len(parts) > 2
		let parts = parts[-2:] " max 2 additional items, this might become a setting
	endif
	" Setup lookups: '1.2.3' becomes [1.2.3] + [3, 2.3]
	let lookup = ''
	for w in reverse(parts)
		let lookup = w . lookup
		if lookup == a:word
			break
		endif
		let lookups += [lookup]
	endfor
	" prefer longest word
	for word in lookups
		" echomsg string(lookups).' current: '.word
		let snippetD = get(funcref#Call(s:snipMate['get_snippets'], [snipMate#ScopesByFile(), word.'*']), word, {})
		if !empty(snippetD)
			let s = s:ChooseSnippet(snippetD)
			if type(s) == type([])
				let snippet = join(s, "\n")
			else
				let snippet = s
			end
			if snippet != '' | break | endif
		endif
	endfor
	if word == '' && a:word != '.' && stridx(a:word, '.') != -1
		let [word, snippet] = s:GetSnippet('.')
	endif
	return [word, snippet]
endf

" snippets: dict containing snippets by name
" usually this is just {'default' : snippet_contents }
fun! s:ChooseSnippet(snippets)
	let snippet = []
	let keys = keys(a:snippets)
	let i = 1
	for snip in keys
		let snippet += [i.'. '.snip]
		let i += 1
	endfor
	if len(snippet) == 1
		" there's only a single snippet, choose it
		let idx = 0
	else
		let idx = tlib#input#List('si','select snippet by name',snippet) -1
		if idx == -1
			return ''
		endif
	endif
	" if a:snippets[..] is a String Call returns it
	" If it's a function or a function string the result is returned
	return funcref#Call(a:snippets[keys(a:snippets)[idx]])
endf

fun! ShowAvailableSnips()
	let line  = getline('.')
	let col   = col('.')
	let word  = matchstr(line, '\S\+\%'.col.'c')
	let words = [word]
	if stridx(word, '.')
		let words += split(word, '\.', 1)
	endif
	let matchlen = 0
	let matches = []
	let snips = funcref#Call(s:snipMate['get_snippets'], [snipMate#ScopesByFile(), word.'*'])


	for trigger in keys(snips)
		for word in words
			if word == ''
				let matches += [trigger] " Show all matches if word is empty
			elseif trigger =~ '^'.word
				let matches += [trigger]
				let len = len(word)
				if len > matchlen | let matchlen = len | endif
			endif
		endfor
	endfor

	" This is to avoid a bug with Vim when using complete(col - matchlen, matches)
	" (Issue#46 on the Google Code snipMate issue tracker).
	call setline(line('.'), substitute(line, repeat('.', matchlen).'\%'.col.'c', '', ''))
	call complete(col, sort(matches))
	return ''
endf

" For autocomplpop
fun! GetSnipsInCurrentScope() 
  let snips = {} 
  for scope in [bufnr('%')] + split(&ft, '\.') + ['_'] 
    call extend(snips, get(s:snippets, scope, {}), 'keep') 
    call extend(snips, get(s:multi_snips, scope, {}), 'keep') 
  endfor 
  return snips 
endf 



" vim:noet:sw=4:ts=4:ft=vim
