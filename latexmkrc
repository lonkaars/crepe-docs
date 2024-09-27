# https://nl.mirrors.cicku.me/ctan/support/latexmk/latexmk.pdf

use File::Spec::Functions;

$pdflatex = "xelatex --interaction=nonstopmode --shell-escape %O %S";
$pdf_mode = 1;
$dvi_mode = 0;
$postscript_mode = 0;
$clean_ext .= ' %R.ist %R.xdy bbl run.xml';
@default_files = (
	'example',
	'plan',
	'research',
	'timerep',
);

push @file_not_found, '^Package .* No file `([^\\\']*)\\\'';
push @generated_exts, 'glo', 'gls', 'glg';
add_cus_dep('aux', 'glstex', 0, 'bib2gls');
sub bib2gls {
	return Run_msg("bib2gls $_[0]");
}

add_cus_dep('puml', 'eps', 0, 'plantuml');
sub plantuml {
  return Run_msg("plantuml -teps $_[0].puml");
}

add_cus_dep('txt', 'tex', 0, 'time2tex');
sub time2tex {
	return Run_msg("python3 @{[catfile('scripts', 'time2tex.py')]} $_[0].txt");
}

add_cus_dep('toml', 'tex', 0, 'reqs2tex');
add_cus_dep('toml', 'aux', 0, 'reqs2tex');
sub reqs2tex {
	return Run_msg("python3 @{[catfile('scripts', 'reqs2tex.py')]} $_[0].toml");
}

# vim:ft=perl

