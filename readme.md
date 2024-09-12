# crêpe docs

systems programming in c++ minor project documentation

Please see [style.md](./style.md) for writing style and
[contributing.md](./contributing.md) for coding and git standards.

## Compilation

- A `latexmkrc` file is provided for copmilation with `latexmk`. The documents
  should also compile under [Visual Studio Code][vscode] using the [LaTeX
  Workshop extension][latexworkshop], as well as [VimTeX][vimtex].
- A [makefile](./makefile) is used to compile other files (e.g. plantuml
  diagrams, [time report](#time-report))
- These documents use fonts loaded using `fontspec`, please see
  [style.md](./style.md) for download links.

## Time report

The time report document includes generated LaTeX code which can be compiled
from [time.txt](./time.txt) using [time2tex.py](./time2tex.py). The
[makefile](./makefile) includes a rule that does this, so `make timerep.pdf`
should be used to compile this document specifically.

## Requirements

TODO: how to store + cross-reference requirements w/o extra latex compilation
runs

[vscode]: https://code.visualstudio.com
[latexworkshop]: https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop
[vimtex]: https://github.com/lervag/vimtex

