# crêpe docs

systems programming in c++ minor project documentation

Please see [style.md](./style.md) for writing style and
[contributing.md](./contributing.md) for coding and git standards. There is
also [an example document](./example.tex) which may be used to copy/paste LaTeX
snippets for specific formatting.

## Compilation

Prerequisites:
- A LaTeX distribution that includes XeLaTeX and latexmk
- PlantUML ([1.2024.7 or later](#plantuml)!)
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

## PlantUML

To check if your PlantUML version is recent enough, run:
```
$ plantuml -version
```

To upgrade PlantUML manually, download the latest (GPL) \.jar from
[here][plantuml], and overwrite the \.jar file installed by your package
manager:

```
$ curl -sLo- https://github.com/plantuml/plantuml/releases/download/v1.2024.7/plantuml-1.2024.7.jar > plantuml.jar
# mv plantuml.jar /usr/share/plantuml/plantuml.jar
```

> NOTE: Ubuntu, Debian and Mint all place PlantUML's \.jar file under
> `/usr/share/plantuml/plantuml.jar`, while it's under
> `/usr/share/java/plantuml/plantuml.jar` on Arch. Check the contents of the
> file returned by `command -v plantuml` to confirm this.

[vscode]: https://code.visualstudio.com
[latexworkshop]: https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop
[vimtex]: https://github.com/lervag/vimtex
[plantuml]: https://plantuml.com/en/download

