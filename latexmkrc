$pdflatex = "xelatex %O %S";
$pdf_mode = 1;
$dvi_mode = 0;
$postscript_mode = 0;

# https://tex.stackexchange.com/questions/400325/latexmkrc-for-bib2gls
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');
add_cus_dep('aux', 'glstex', 0, 'run_bib2gls');

sub run_makeglossaries {
  if ( $silent ) {
    system "makeglossaries -q '$_[0]'";
  } else {
    system "makeglossaries '$_[0]'";
  };
}

sub run_bib2gls {
  if ( $silent ) {
    my $ret = system "bib2gls --silent --group '$_[0]'";
  } else {
    my $ret = system "bib2gls --group '$_[0]'";
  };
  my ($base, $path) = fileparse( $_[0] );
  if ($path && -e "$base.glstex") {
    rename "$base.glstex", "$path$base.glstex";
  }
  # Analyze log file.
  local *LOG;
  $LOG = "$_[0].glg";
  if (!$ret && -e $LOG) {
    open LOG, "<$LOG";
    while (<LOG>) {
      if (/^Reading (.*\.bib)\s$/) {
        rdb_ensure_file( $rule, $1 );
      }
    }
    close LOG;
  }
  return $ret;
}

push @file_not_found, '^Package .* No file `([^\\\']*)\\\'';
push @generated_exts, 'glo', 'gls', 'glg';
push @generated_exts, 'acn', 'acr', 'alg';
$clean_ext .= ' %R.ist %R.xdy';
$clean_ext .= ' bbl run.xml';

