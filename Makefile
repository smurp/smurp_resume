# Makefile to build smurp_{cv,resume}{,_nomug}.pdf from .tex sources

help :
	clear ;\
	echo "all -- build if needed and open" ;\
	echo "watch -- run 'make all' every 5 seconds" ;\
	echo "push -- push to github" ;\
        echo "publish -- deploy output to smurp.com";\
	echo "";

# Define the .tex files
TEX_FILES = smurp_cv.tex smurp_resume.tex smurp_resume_nomug.tex smurp_cv_nomug.tex

# Define the .pdf files
PDF_FILES = $(TEX_FILES:.tex=.pdf)

# Default target
all: $(PDF_FILES)

languages.tex : languages.py
	./languages.py > languages.tex

TEX_DEPS = section/*.tex globals.tex mugshooter.tex languages.tex

# Rule to build a .pdf file from a .tex file
%.pdf: %.tex $(TEX_DEPS)
	pdflatex $<
	open $@

# Clean target to remove generated files
clean:
	rm -f *.aux *.log *.out $(PDF_FILES)

open:
	open $(PDF_FILES)

push:
	git push

publish:
	cp $(PDF_FILES) ../smurp_com/
	cd ../smurp_com/ && pwd
	git commit  -m "update cv and resume" $(PDF_FILES)
	git push github

watch:
	while true; do make all ; sleep 10 ; done

# PHONY targets
.PHONY: all clean
