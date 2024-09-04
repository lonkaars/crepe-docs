" fix vimtex highlighting for custom verbatim commands
syntax match texCmdVerb "\\codeinline\>\*\?" nextgroup=texVerbZoneInline
call vimtex#syntax#core#new_arg('texVerbZoneInline', {
			\ 'contains': '',
			\ 'matcher': 'start="{" end="}"'
			\})
" and \begin{blockcode} ... \end{blockcode}
call vimtex#syntax#core#new_env({
			\ 'name': 'blockcode',
			\ 'region': 'texVerbZone',
			\})

