FILE=report

LODFIGS = $(patsubst %.odg,%.pdf,$(wildcard *.odg))

all: $(FILE).pdf
	evince $< &
	
$(FILE).pdf: $(wildcard *.tex) $(LODFIGS)
	export TEXINPUTS=$(TEXINPUTS)
	
	pdflatex $(FILE).tex
	pdflatex $(FILE).tex
	pdflatex $(FILE).tex
	
%.pdf: %.odg
	soffice --headless --convert-to pdf $<
	
clean:
	@rm -rf *.aux *.bbl *.blg *.glg *.glo *.gls *.ilg *.ist *.lof
	@rm -rf *.log *.lot *.nlo *.nls *.out *.toc *~ *.*% ./*.pdf ./*.eps
	
.PHONY: all clean
