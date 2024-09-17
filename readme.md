# crêpe docs

systems programming in c++ minor project documentation

Please see [style.md](./style.md) for writing style and
[contributing.md](./contributing.md) for coding and git standards.

## Compilation

Requirements:

- A LaTeX distribution that includes the XeLaTeX compiler and latexmk
- PlantUML
- Python 3
- Fonts (see see [style.md](./style.md) for download links)

A `latexmkrc` file is provided for copmilation with latexmk. The documents
should also compile under [Visual Studio Code][vscode] using the [LaTeX
Workshop extension][latexworkshop], as well as [VimTeX][vimtex].

## TODO

- Requirement cross-references are broken (they print both the label and the
  path to the other document, should be label only). Interesting:
  `\creflabelformat` and `\@templabel` (inside #2 of `\creflabelformat`).

[vscode]: https://code.visualstudio.com
[latexworkshop]: https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop
[vimtex]: https://github.com/lervag/vimtex

