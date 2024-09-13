all: plan.pdf
all: research.pdf

LATEXMKFLAGS += -cd
LATEXMKFLAGS += -interaction=nonstopmode
%.pdf: %.tex
	-latexmk $(LATEXMKFLAGS) $<

%.puml.pdf: %.puml
	plantuml -tpdf $<
	mv $*.pdf $@

%.tex: %.txt
	./time2tex.py $< > $@

timerep.pdf: time.tex

