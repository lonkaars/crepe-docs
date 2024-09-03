\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{school-assignment}[2024-01-20 class school-assignment]

% based on article
\LoadClass{article}

% default word page setup
\PassOptionsToPackage{margin=1in}{geometry}
\PassOptionsToPackage{a4paper}{geometry}
% confusing to acrobat/firefox users
\PassOptionsToPackage{hidelinks}{hyperref}
\PassOptionsToPackage{english}{babel}
\PassOptionsToPackage{noabbrev}{cleveref}
\PassOptionsToPackage{nosort}{cleveref}

% frequently used packages
\RequirePackage{geometry}
\RequirePackage{float}
\RequirePackage{babel}
\RequirePackage{siunitx}
\RequirePackage{csquotes}
\RequirePackage{parskip}
\RequirePackage{fontspec}
\RequirePackage{tabularx}
\RequirePackage{booktabs}
\RequirePackage{needspace}
\RequirePackage{hyperref}
\RequirePackage{microtype}
\RequirePackage{xcolor}
\RequirePackage{etoolbox}
\RequirePackage{graphicx}
\RequirePackage{unicode-math}
\RequirePackage{amsmath}
\RequirePackage{cleveref}

% font style
\setmainfont{TeX Gyre Schola}
\setmathfont{TeX Gyre Schola Math}
\setsansfont{Inter}
\setmonofont[Scale=0.85]{JetBrains Mono}

% fix fonts w/ siunitx
\sisetup{detect-all = true}

% no indented paragraphs, just skip
\parindent=0mm
\bigskipamount=7mm
\medskipamount=4mm

% \maketitle format
\makeatletter
\let\@project\relax
\def\project#1{\def\@project{#1}}
\let\@organization\relax
\def\organization#1{\def\@organization{#1}}
\let\@version\relax
\def\version#1{\def\@version{#1}}
\def\@maketitle{%
	\centering%
	\parskip=0pt%
	\vspace*{2in}%
	\par{%
		\par{%
			\bfseries\Huge%
			\strut\@title\strut%
		}%
		\par{%
			\Large%
			\strut\@project\strut%
		}%
	}%
	\vspace{1in}%
	\par{%
		\par{%
			\def\and{\par}%
			\parskip=0.5ex%
			\strut\@author\strut%
		}%
		\vspace{2em}%
		\par{%
			\footnotesize\itshape%
			\strut\@organization\strut%
		}%
	}%
	\vfill\flushright%
	\par{%
		\par{\strut{}Version \@version\strut}%
		\par{\strut\@date\strut}%
	}%
	\par\vspace*{2in}%
}
\makeatother

% float here by default
\usepackage{float}
\makeatletter
\def\fps@figure{H}
\def\fps@table{H}
\makeatother

% always start with title page
\AtBeginDocument{
	\clearpage
	\begin{titlepage}
	\maketitle
	\thispagestyle{empty}
	\end{titlepage}
}

% store figure/table count in macros
\makeatletter
\AtEndDocument{
	\immediate\write\@mainaux{\string\global\string\def\string\figurecount{\the\value{figure}}}
	\immediate\write\@mainaux{\string\global\string\def\string\tablecount{\the\value{table}}}
	\immediate\write\@mainaux{\string\global\string\def\string\pagecount{\thepage}}
}
\makeatother

% generate table of contents, figures, tables
\def\tablestables{%
	\tableofcontents%
	\ifnumgreater{\figurecount}{0}{\listoffigures}{}%
	\ifnumgreater{\tablecount}{0}{\listoftables}{}%
}

