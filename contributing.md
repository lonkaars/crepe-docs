This document is an extension of the [crêpe engine contribution
guidelines][crepe-engine-contrib]. Rules in this document override those in the
other document.

# Code style

- Indent using tabs
- Wrap long lines at column 80
- ASCII only (LaTeX syntax should be used instead of UTF-8, i.e. `fa\c{c}ade`
  instead of `façade`, `---` instead of `—`)
- Images should be placed in the img/ folder
- Labels and bibliography keys should only consist of characters from the
  following set: `[a-z0-9:-]` (lower-case, numbers, colon, dash).
- Both single and double quotes are opened using backtick(s)
  (<code>&#96</code>) and closed using single quote(s) (`'`), i.e.
  <code>&#96&#96like this''</code> or <code>&#96this'</code>
- Only environments indent the LaTeX source code
- Insert a non-breaking space (`~`) after (Latin) abbreviations such as "i.e."
  or "e.g.". Never place a comma after either of these.
- Multiple references (both `\cref` and `\autocite`) should be done in a single
  command (i.e. `\cref{fig:a,fig:b}` and `\autocite{source1,source2}`)

# Banned practices

- **Using `\newpage`**

  Widows and orphans are handled by LaTeX. If you want to prevent a page break
  from occurring between two paragraphs, use the `\noparbreak` command at the
  end of the first paragraph. For larger chunks, the `\needspace{<length>}`
  command should be used instead.
- **Using `\href`**

  Add the source in [sources.bib](#sources) and cite this source instead.
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

These items can be referenced using the `\cref` command.

## Sources

Bibliography entries work with a similar label system (usually called *keys*).
Since these exist in a registry separate from `\label` entries, these do not
need to be prefixed. All sources are stored in [sources.bib](./sources.bib).
There is a very helpful [cheat sheet][biblatex-cheat-sheet] online that
showcases different entry types and their fields.

For consistency, the following format for keys is preferred: `authority:topic`.
The `authority` part refers to a company, website or author, and `topic` refers
to a title, chip model number, etc. depending on the type of document being
referenced.

## Glossary

Glossary entries are stored in [glossary.bib](./glossary.bib). This file has
the same structure as the bibliography, but with different key types:

|type|usage|
|-|-|
|`@abbreviation`|Abbreviations (long version inserted on first occurrence)|
|`@acronym`|Acronyms (long version only in glossary)|
|`@entry`|Generic entries / words|

The keys in the glossary do not have to be prefixed, and should be short as
they should be inserted frequently. Glossary entries can be used with the
following commands:

|command|usage|
|-|-|
|`\gls{<key>}`|regular|
|`\glspl{<key>}`|plural|
|`\Gls{<key>}`|capitalized (at start of sentence)|
|`\Glspl{<key>}`|capitalized plural|

> [!NOTE]
> Glossary entries should not be inserted in figure captions or section
> headings!

[crepe-engine-contrib]: https://github.com/lonkaars/crepe/blob/master/contributing.md
[biblatex-cheat-sheet]: https://tug.ctan.org/info/biblatex-cheatsheet/biblatex-cheatsheet.pdf

