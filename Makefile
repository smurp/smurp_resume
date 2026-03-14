# Makefile to build {pv}_{cv,resume}{,_nomug}.pdf from .tex sources
# where {pv} is each profile version listed in PROFILE_VERSIONS.
#
# To add a new profile version:
#   1. Add the name to PROFILE_VERSIONS below
#   2. Create section/<name>/profile.tex (and optionally override other sections)
#   3. Run 'make'

help:
	@echo "all     -- build all PDFs"
	@echo "watch   -- run 'make all' every 10 seconds"
	@echo "push    -- push to github"
	@echo "publish -- deploy output to smurp.com"
	@echo "clean   -- remove generated files"
	@echo ""

# Profile versions -- each gets resume/cv x mug/nomug = 4 PDFs
PROFILE_VERSIONS = smurp sfm

# Derive driver .tex and output .pdf file names
DRIVER_RESUME_TEX     = $(foreach pv,$(PROFILE_VERSIONS),$(pv)_resume.tex)
DRIVER_CV_TEX         = $(foreach pv,$(PROFILE_VERSIONS),$(pv)_cv.tex)
DRIVER_RESUME_NM_TEX  = $(foreach pv,$(PROFILE_VERSIONS),$(pv)_resume_nomug.tex)
DRIVER_CV_NM_TEX      = $(foreach pv,$(PROFILE_VERSIONS),$(pv)_cv_nomug.tex)
DRIVER_TEX = $(DRIVER_RESUME_TEX) $(DRIVER_CV_TEX) $(DRIVER_RESUME_NM_TEX) $(DRIVER_CV_NM_TEX)
PDF_FILES  = $(DRIVER_TEX:.tex=.pdf)

# Default target
all: $(PDF_FILES)

# Section and template dependencies
TEX_DEPS = base_resume.tex base_cv.tex globals.tex mugshooter.tex \
           $(wildcard section/*.tex) $(wildcard section/*/*.tex)

languages.tex: languages.py
	./languages.py > languages.tex

# Auto-generate driver .tex files (static pattern rules)
$(DRIVER_RESUME_TEX): %_resume.tex: Makefile
	@echo '\def\profileVersion{$*}' > $@
	@echo '\input{base_resume}' >> $@

$(DRIVER_CV_TEX): %_cv.tex: Makefile
	@echo '\def\profileVersion{$*}' > $@
	@echo '\input{base_cv}' >> $@

$(DRIVER_RESUME_NM_TEX): %_resume_nomug.tex: Makefile
	@echo '\def\mugshot{}' > $@
	@echo '\def\profileVersion{$*}' >> $@
	@echo '\input{base_resume}' >> $@

$(DRIVER_CV_NM_TEX): %_cv_nomug.tex: Makefile
	@echo '\def\mugshot{}' > $@
	@echo '\def\profileVersion{$*}' >> $@
	@echo '\input{base_cv}' >> $@

# Rule to build a .pdf from a .tex file
%.pdf: %.tex $(TEX_DEPS) languages.tex
	pdflatex $<

open:
	open $(PDF_FILES)

push:
	git push

publish:
	cp $(PDF_FILES) ../smurp_com/
	cd ../smurp_com/ && pwd
	git commit -m "update cv and resume" $(PDF_FILES)
	git push github

watch:
	while true; do make all; sleep 10; done

clean:
	rm -f *.aux *.log *.out $(PDF_FILES) $(DRIVER_TEX)

.PHONY: all clean help open push publish watch
