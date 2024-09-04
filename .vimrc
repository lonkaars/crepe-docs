" fix vimtex highlighting for \code{}
syntax match texCmdVerb "\\code\>\*\?" nextgroup=texVerbZoneInline
call vimtex#syntax#core#new_arg('texVerbZoneInline', {
			\ 'contains': '',
			\ 'matcher': 'start="{" end="}"'
			\})
" and \begin{codeblock} ... \end{codeblock}
call vimtex#syntax#core#new_env({
			\ 'name': 'codeblock',
			\ 'region': 'texVerbZone',
			\})

