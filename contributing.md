This document is an extension of the [crêpe engine contribution
guidelines][crepe-engine-contrib]. Rules in this document override those in the
other document.

# Versioning

- TODO: discuss w/ group

# Code style

- Indent using tabs
- Wrap long lines at column 80
- Diacritical marks should be represented in ASCII using LaTeX syntax instead
  of using UTF-8 (i.e. `fa\c{c}ade` instead of `façade`)
- Images should be placed in the img/ folder
- Labels and bibliography keys should only consist of characters from the
  following set: `[a-z0-9:-]` (lower-case, numbers, colon, dash).
- Quotes are opened with the tilde (<code>`</code>)

# Banned practices

- **Using `\newpage`**

  Widows and orphans are handled by LaTeX. If you want to prevent a page break
  from occurring between two paragraphs, use the `\noparbreak` command at the
  end of the first paragraph. For larger chunks, the `\needspace{<length>}`
  command should be used instead.
- **Using `\href`**

  Add the source in sources.bib and cite this source instead.
- **Using `\textbf` or `\textit` to emphasize**

  Use `\emph`, single quotes or an em dash (`---`) instead.

# References

References are used in the LaTeX source code, and should be recognizable
without having to compile the document first. Reference names should be short
and descriptive, so avoid referring to generated numbers (i.e.
`sec:release-cycle` instead of `sec:1.2.3`) or arbitrary info such as publish
year (i.e. `book:struct-comp-org` instead of `TanenbaumAustin12`).

## Labels

Please use prefixes to 'namespace' `\label`s:

|type|prefix|
|-|-|
|Figures|`fig:`|
|Tables|`tab:`|
|Sections|`sec:`|
|List items (i.e. `enumerate`/`itemize`)|`item:`|

## Sources

Bibliography entries work with a similar label system (usually called *keys*).
Since these exist in a registry separate from `\label` entries, these do not
need to be prefixed.

For consistency, the following format is preferred: `authority:topic`. The
`authority` part refers to a company, website or author, and `topic` refers to
a title, chip model number, etc. depending on the type of document being
referenced.

<!--
TODO
- Cross-references and citations should be handled using cleveref
-->

[crepe-engine-contrib]: https://github.com/lonkaars/crepe/blob/master/contributing.md

