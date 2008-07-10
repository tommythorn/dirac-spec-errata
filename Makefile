
SRC = layout-fullsize.tex
SUBDIRS = figs
TEXINPUTS = tools/::

export TEXINPUTS
.PHONY: all clean distclean subdirs $(SUBDIRS)

all: $(patsubst %.tex,%.pdf,$(SRC))

include .depends

.depends:
	touch .version-date
	-latex -recorder -interaction=batchmode layout-fullsize.tex
	perl tools/mkdep.pl layout-fullsize.tex > .depends
	-rm *.dvi *.aux

version:
	sh -c 'pwd -P' > .version-date
	date --iso-8601=seconds >> .version-date

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean: subdirs
	-rm -f *.aux *.dvi *.fls *.log *.pdf *.toc

distclean: clean subdirs
	-rm -f .depends .version-date

.INTERMEDIATE: %.dvi

%.dvi: %.tex version
	-latex $<
	-latex $<
	-latex $<

%.pdf: %.dvi
	dvipdfm -p a4 -o $@ $<

%.eps: %.fig
	fig2dev -Leps $< > $@

%.pdf: %.fig
	fig2dev -Lpdf $< > $@
