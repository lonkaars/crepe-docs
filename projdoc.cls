\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{projdoc}[2024-09-03 class projdoc]

% project defaults
\makeatletter
\def\@project{Project cr\^epe}
\def\@organization{Avans University of Applied Sciences}
\def\@author{%
	Loek Le Blansch\and%
	Wouter Boerenkamps\and%
	Jaro Rutjes\and%
	Max Smits\and%
	Niels Stunnebrink%
}
\makeatother

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
\PassOptionsToPackage{nameinlink}{cleveref}
\PassOptionsToPackage{obeyspaces}{url}
\PassOptionsToPackage{toc=false}{glossaries}
\PassOptionsToPackage{record}{glossaries-extra}
\PassOptionsToPackage{
	backend=biber,
	bibencoding=utf8,
	style=iso-numeric,
	% Technically, Avans University of Applied Sciences requires that we always use APA
	% style references, but this often results in ugly citations when working with
	% technical or online resources. At the end of the day, the bibliography is there
	% to prove we didn't plagiarize or make shit up, so ISO 690 is *probably* fine.
	autocite=plain,
}{biblatex}

% frequently used packages
\RequirePackage{geometry}
\RequirePackage{float}
\RequirePackage{babel}
\RequirePackage{siunitx}
\RequirePackage{csquotes}
\RequirePackage{url}
\RequirePackage{fancyvrb}
\RequirePackage{parskip}
\RequirePackage{fontspec}
\RequirePackage{tabularx}
\RequirePackage{booktabs}
\RequirePackage{needspace}
\RequirePackage{xr-hyper}
\RequirePackage{hyperref}
\RequirePackage{microtype}
\RequirePackage{xcolor}
\RequirePackage{etoolbox}
\RequirePackage{graphicx}
\RequirePackage{unicode-math}
\RequirePackage{amsmath}
\RequirePackage{cleveref}
\RequirePackage{adjustbox}
\RequirePackage{xparse}
\RequirePackage{biblatex}
\RequirePackage{glossaries}
\RequirePackage{glossaries-extra}
\RequirePackage{ifdraft}
\RequirePackage{enumitem}
\RequirePackage{subcaption}
\RequirePackage{multicol}
\RequirePackage{comparison} % ./comparison.sty
\RequirePackage{xstring}

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

% number paragraphs by default
\setcounter{secnumdepth}{4}

% section placement / appearance
\newlength{\sectionpenalty}
\newlength{\subsectionpenalty}
\newlength{\subsubsectionpenalty}
\setlength{\sectionpenalty}{0.4\textheight}
\setlength{\subsectionpenalty}{0.1\textheight}
\setlength{\subsubsectionpenalty}{0pt}
\def\penaltycheck#1{\ifdimgreater{#1}{0pt}{\needspace{#1}}{}}
\ifdraft{\def\penaltycheck#1{\relax}}{}
\makeatletter
\renewcommand\section{%
	\@startsection{section}{1}%
		{0pt}%
		{1.50em}%
		{1.50ex}%
		{\penaltycheck{\sectionpenalty}\normalfont\bfseries\Large}%
}
\renewcommand\subsection{%
	\@startsection{subsection}{2}%
		{0pt}%
		{1.25em}%
		{1.25ex}%
		{\penaltycheck{\subsectionpenalty}\normalfont\bfseries\large}%
}
\renewcommand\subsubsection{%
	\@startsection{subsubsection}{2}%
		{0pt}%
		{1.00em}%
		{1.00ex}%
		{\penaltycheck{\subsubsectionpenalty}\normalfont\bfseries\normalsize}%
}
\makeatother

% default tight list spacing
\makeatletter
\newlength{\style@parsep}
\newlength{\style@itemsep}
\newlength{\style@itemizemargin}
\setlength{\style@parsep}{1mm}
\setlength{\style@itemsep}{1mm}
\setlength{\style@itemizemargin}{2mm}
\setlist{
	topsep=\dimexpr\style@itemizemargin-\parskip\relax,
	itemsep=\dimexpr\style@itemsep-\style@parsep\relax,
	parsep=\style@parsep,
}
\def\projdoc@description@before{%
	\renewcommand\makelabel[1]{%
		{\bfseries ##1}:%
	}%
}
\newlength\projdoc@description@leftmargin%
\projdoc@description@leftmargin=3em%
\newlength\projdoc@description@labelindent%
\projdoc@description@labelindent=3ex%
\def\projdoc@setdescriptionstyle{%
	\setdescription{
		before={\projdoc@description@before},
		leftmargin=\projdoc@description@leftmargin,
		labelindent=\projdoc@description@labelindent,
	}%
}
\projdoc@setdescriptionstyle%
\makeatother

% create a label using \customlabel[<creftype>]{<refname>}{<reftext>} that displays
% <reftext> when \ref{<refname>} is used, or <creftype> <reftext> when
% \cref{<refname>} is used
\makeatletter
\NewDocumentCommand{\customlabel}{omm}{%
	\begingroup
	\cref@constructprefix{#1}{\cref@result}%
	\protected@edef\@currentlabel{#3}%
	\protected@edef\@currentlabelname{#3}%
	\protected@edef\cref@currentlabel{[#1][][\cref@result]#3}
	\label[#1]{#2}%
	\endgroup
}
\makeatother

% \maketitle format
\makeatletter
\def\project#1{\def\@project{#1}}
\def\organization#1{\def\@organization{#1}}
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
		\par{\strut\@date\strut}%
		\begingroup%
		\endlinechar=\m@ne\everyeof{\noexpand}%
		\edef\x{%
			\endgroup%
			\def\noexpand\commit{\@@input|"git rev-parse --short HEAD" }%
		}%
		\x%
		\par{\strut\footnotesize({\ttfamily\commit})\strut}%
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

% bibliography
\addbibresource{sources.bib}

% glossary
\GlsXtrLoadResources[
	src={./glossary.bib},
	selection={recorded and deps and see},
]

% allow cross-references to requirements.pdf from all documents except
% requirements.pdf itself
\IfEq*{\jobname}{requirements}{}{
	\externaldocument{reqs}[requirements.pdf]
}

% default document header/trailer
\makeatletter
\def\projdoc@header{
	% start with title page
	\clearpage
	\begin{titlepage}
	\maketitle
	\thispagestyle{empty}
	\end{titlepage}
}
\newbool{projdoc@used@cite}
\newbool{projdoc@used@gls}
\apptocmd{\abx@aux@cite}{\global\booltrue{projdoc@used@cite}}{}{}
\apptocmd{\glsxtr@record}{\global\booltrue{projdoc@used@gls}}{}{}
\def\projdoc@trailer{
	% bibliography (if citations used)
	\ifbool{projdoc@used@cite}{%
		\hfuzz=50pt% reduce overfull hbox warnings for bibliography (mostly URLs)
		\printbibliography%
	}{}%
	% glossary
	\ifbool{projdoc@used@gls}{%
		\projdoc@description@leftmargin=2ex%
		\projdoc@description@labelindent=0pt%
		\projdoc@setdescriptionstyle%
		\section*{Glossary}%
		\begin{multicols}{2}%
			\renewcommand{\glossarysection}[2][]{}%
			\printunsrtglossary%
		\end{multicols}%
	}{}%
}
\AtBeginDocument{\projdoc@header}
\AtEndDocument{\projdoc@trailer}
\makeatother

% store figure/table count in macros
\makeatletter
\def\figurecount{0}%
\def\tablecount{0}%
\def\pagecount{0}%
\AtEndDocument{
	\immediate\write\@mainaux{\string\global\string\def\string\figurecount{\the\value{figure}}}
	\immediate\write\@mainaux{\string\global\string\def\string\tablecount{\the\value{table}}}
	\immediate\write\@mainaux{\string\global\string\def\string\pagecount{\thepage}}
}
\makeatother

% generate table of contents, figures, tables
\def\tablestables{%
	\tableofcontents%
	\label{sec:toc}%
	\ifnumgreater{\figurecount}{0}{\listoffigures}{}%
	\label{sec:lof}%
	\ifnumgreater{\tablecount}{0}{\listoftables}{}%
	\label{sec:lot}%
}

% code
\DeclareUrlCommand\codeinline{%
	\urlstyle{tt}%
	\def\codebreak{\discretionary{\hbox{~\textbackslash{}}}{\hbox{~~}}{}}%
	\def\UrlSpecials{%
		\do\/{\hbox{/}\codebreak}%
		\do\_{\hbox{\_}\codebreak}%
		\do\ {\hbox{\ }\codebreak}%
		\do\-{\hbox{-}\codebreak}%
	}%
	\def\UrlNoBreaks{%
		\do\+%
		\do\.%
		\do\[%
		\do\]%
	}%
	\def\UrlLeft{\hbox{\,}}%
	\def\UrlRight{\hbox{\,}}%
}
\DefineVerbatimEnvironment{blockcode}{Verbatim}{
	tabsize=2,
	obeytabs,
}

% scale down image if it exceeds page margins
\newcommand{\fitimg}[1]{%
	\adjustbox{max width=\linewidth}{#1}%
}

% adjust scale for puml diagrams
\newcommand{\includepumldiag}[1]{%
	\StrSubstitute{#1}{.puml}{.eps}[\filename]%
	\fitimg{\includegraphics[scale=0.65]{\filename}}%
}

% prevent page break between two paragraphs
\makeatletter
\newcommand\noparbreak{\par\nobreak\@afterheading}
\makeatother

% cleveref extra types
\crefname{paragraph}{paragraph}{paragraphs}
\Crefname{paragraph}{Paragraph}{Paragraphs}
\crefname{requirement}{requirement}{requirements}
\Crefname{requirement}{Requirement}{Requirements}
\crefname{test}{test}{tests}
\Crefname{test}{Test}{Tests}

% fix cleveref showing filename to external cross-reference
% see <https://tex.stackexchange.com/a/708445/211562>
% edited from cleveref source
\makeatletter
\def\cref@getref#1#2{%
	\expandafter\let\expandafter#2\csname r@#1@cref\endcsname%
	\expandafter\expandafter\expandafter\def%
		\expandafter\expandafter\expandafter#2%
		\expandafter\expandafter\expandafter{%
			\expandafter\@firstoffive#2}}%
\def\cpageref@getref#1#2{%
	\expandafter\let\expandafter#2\csname r@#1@cref\endcsname%
	\expandafter\expandafter\expandafter\def%
		\expandafter\expandafter\expandafter#2%
		\expandafter\expandafter\expandafter{%
			\expandafter\@secondoffive#2}}%
\AtBeginDocument{%
	\def\label@noarg#1{%
		\cref@old@label{#1}%
		\@bsphack%
		\edef\@tempa{{page}{\the\c@page}}%
		\setcounter{page}{1}%
		\edef\@tempb{\thepage}%
		\expandafter\setcounter\@tempa%
		\cref@constructprefix{page}{\cref@result}%
		\protected@write\@auxout{}{%
			\string\newlabel{#1@cref}{%
				{\cref@currentlabel}%
				{[\@tempb][\arabic{page}][\cref@result]\thepage}%
				{}%
				{}%
				{}%
			}%
		}%
		\@esphack%
	}%
	\def\label@optarg[#1]#2{%
		\cref@old@label{#2}%
		\@bsphack%
		\edef\@tempa{{page}{\the\c@page}}%
		\setcounter{page}{1}%
		\edef\@tempb{\thepage}%
		\expandafter\setcounter\@tempa%
		\cref@constructprefix{page}{\cref@result}%
		\protected@edef\cref@currentlabel{%
			\expandafter\cref@override@label@type%
			\cref@currentlabel\@nil{#1}%
		}%
		\protected@write\@auxout{}{%
			\string\newlabel{#2@cref}{%
				{\cref@currentlabel}%
				{[\@tempb][\arabic{page}][\cref@result]\thepage}%
				{}%
				{}%
				{}%
			}%
		}%
		\@esphack%
	}%
}
\makeatother

% missing reference marker
\def\mref{\textsuperscript{\textit{\,ref?}}}

