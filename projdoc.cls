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
\PassOptionsToPackage{nameinlink}{cleveref}
\PassOptionsToPackage{obeyspaces}{url}

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
\RequirePackage{ifdraft}
\RequirePackage{enumitem}
\RequirePackage{subcaption}

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

% bibliography
\usepackage[
	backend=biber,
	bibencoding=utf8,
	style=iso-numeric,
	% Technically, Avans University of Applied Sciences requires that we always use APA
	% style references, but this often results in ugly citations when working with
	% technical or online resources. At the end of the day, the bibliography is there
	% to prove we didn't plagiarize or make shit up, so ISO 690 is *probably* fine.
	autocite=plain,
]{biblatex}
\addbibresource{sources.bib}

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
\newbool{projdoc@cited}
\apptocmd{\abx@aux@cite}{\global\booltrue{projdoc@cited}}{}{}
\def\projdoc@trailer{
	% end with bibliography (if citations used)
	\ifbool{projdoc@cited}{\printbibliography}{}%
}
\AtBeginDocument{\projdoc@header}
\AtEndDocument{\projdoc@trailer}
\makeatother

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
	\fitimg{\includegraphics[scale=0.6]{#1}}%
}

