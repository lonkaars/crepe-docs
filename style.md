This document contains requirements for all project documentation. Specific
LaTeX commands and LaTeX source style requirements are detailed in
[contributing.md](./contributing.md), and [example.tex](./example.tex) contains
a number of frequently used snippets that may be used as a cheat-sheet style
reference.

# Fonts

The documents use the following fonts. All of these are free and open source,
and are likely available from your system's package manager if you are using
Linux.

If the documents fail to compile after installing these fonts, please check if
you are using a LaTeX compiler with support for the `fontspec` package (i.e.
`xelatex` or `lualatex`). The included `latexmkrc` file \*should\* cover LaTeX
workshop and VimTeX.

|Family|Usage|Typeface|
|-|-|-|
|serif|Body text (default)|[TeX Gyre Schola][texgyreschola]|
|math|Math|[TeX Gyre Schola Math][texgyreschola-math]|
|sans-serif|Figures|[Inter][inter]|
|monospace|URLs, code listings|[JetBrains Mono][jetbrains-mono]|

[inter]: https://rsms.me/inter
[texgyreschola]: https://www.gust.org.pl/projects/e-foundry/tex-gyre/schola/index_html
[texgyreschola-math]: https://www.gust.org.pl/projects/e-foundry/tg-math/download/index_html#Schola_Math
[jetbrains-mono]: https://www.jetbrains.com/lp/mono

# Spelling

- All documentation is written in U.S. English
- Section headers are in sentence case (i.e. only the first word and proper
  nouns are capitalized)

# Grammar

## Comma And

**In lists**, the last element is mentioned using the word 'and', *without* a
comma.

**When joining independent clauses**, keep a comma before the word 'and'.
Usually, this comma can be left out for short clauses, but we keep them in for
consistency.

**Good examples:**

> The first, second and last items.
>
> Action X was performed, and this had Y impact.

# Figures

Non-raster figures are preferred over rasterized figures (where applicable).
Please note that LaTeX does not support SVG images, and these need to be
converted to PDF (e.g. using `svg2pdf` on linux).

Raster images should only be used when the source is already in a raster format
(e.g. for photos) or when otherwise impractical.

# References

- When a library or piece of software is introduced in a document, reference
  the project homepage using the bibliography.
- Direct quotations or paraphased text must be cited.
- Acronyms, abbreviations and jargon reference the glossary.
- All figures and tables must be referenced in the body text. Don't write
  paragraphs that 'lead up' to figures, as this forces LaTeX to not break the
  page between the paragraph and figure.

# Document structure

- Use `\section`, `\subsection`, `\subsubsection` and `\paragraph` to insert
  headings.

