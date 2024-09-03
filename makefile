all: plan.pdf

LATEXMKFLAGS += -cd
LATEXMKFLAGS += -interaction=nonstopmode
%.pdf: %.tex
	-latexmk $(LATEXMKFLAGS) $<

%.puml.pdf: %.puml
	plantuml -tpdf $<
	mv $*.pdf $@

