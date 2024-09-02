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
\RequirePackage{smartref}

% font style
\setmainfont{TeX Gyre Schola}
\setmonofont[Scale=0.85]{JetBrainsMono Nerd Font}

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
\def\@maketitle{
	\centering
	\vspace*{2in}
	{
		{
			\bfseries\Huge
			\strut\@title\strut
		}\\% no parskip
		{
			\Large
			\strut\@project\strut
		}
	}

	\vspace{1in}

	{
		{
			\def\and{\par}
			\parskip=0.5ex
			\strut\@author\strut
		}

		\vspace{2em}

		{\strut\@organization\strut}
	}

	\vfill
	\flushright

	{
		{
			\strut{}Version \@version\strut
		}

		{
			\strut\@date\strut
		}
	}

	\vspace*{2in}
}
\makeatother

% always start with title page
\AtBeginDocument{
	\clearpage
	\begin{titlepage}
	\maketitle
	\thispagestyle{empty}
	\end{titlepage}
}

