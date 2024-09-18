# crêpe docs

systems programming in c++ minor project documentation

Please see [style.md](./style.md) for writing style and
[contributing.md](./contributing.md) for coding and git standards. There is
also [an example document](./example.tex) which may be used to copy/paste LaTeX
snippets for specific formatting.

## Compilation

Prerequisites:
- A LaTeX distribution that includes XeLaTeX and latexmk
- PlantUML
- Python 3
- Fonts (see see [style.md](./style.md) for download links)

All documents are compiled using latexmk, and this repository contains
additional configuration files for the following editors:
- [Visual Studio Code][vscode] + [LaTeX Workshop][latexworkshop]
- (Neo)Vim + [VimTeX][vimtex] (source `.vimrc` to fix custom verb command
  highlighting)

## Special files

- `time.txt` contains tracked time for each team member. This file is
  automatically converted using [time2tex](scripts/time2tex.py) when compiling
  [timerep.tex](./timerep.tex).
- `reqs.toml` contains the project requirements. This file is converted using
  [reqs2tex](scripts/reqs2tex.py) for [requirements.tex](./requirements.tex)
  and also generates an `.aux` file for cross-referencing the requirements from
  other documents.
- `sources.bib` contains all bibliography entries / references
- `glossary.bib` contains all glossary entries

[vscode]: https://code.visualstudio.com
[latexworkshop]: https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop
[vimtex]: https://github.com/lervag/vimtex

