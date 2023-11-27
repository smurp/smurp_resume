files=smurp_resume.tex smurp_resume.pdf smurp_resume.ps res.sty res-sample2.tex smurp_resume.html Makefile

help :
	clear ;\
	echo "all -- do the whole shebang" ;\
	echo "pdf -- build the pdf file by placing a ps in the watched directory" ;\
	echo "ps -- build a postscript file by running dvips on the dvi file";\
	echo "dvi -- create a dvi file by running latex on the resume";\
	echo "txt -- create a text-only version of the resume" ;\
	echo "html -- create an html version of the resume" ;\
	echo "docx -- create a Word version of the resume WIP: misses company names" ;\
	echo "print -- print the ps file";\
	echo "xdvi -- view the dvi using xdvi";\
	echo "";

LATEX_FILE = smurp_resume
PDF_FILE = $(LATEX_FILE).pdf
PS_FILE = $(LATEX_FILE).ps

all : clean pdf docx html open

open :
	open ${PDF_FILE}

pdf : ps
	ps2pdf $(PS_FILE) $(PDF_FILE)
	ps2pdf smurp_resume_berlin_visa_2017.ps smurp_resume_berlin_visa_2017.pdf

ps : dvi dvips

print : ps
	lpr -Plp0 smurp_resume.ps

dvi : clean
	./pivot_data_structure.py > langauges_formats_apis_and_dtds.tex
	latex smurp_resume_berlin_visa_2017.tex && touch dvi
	latex smurp_resume.tex && touch dvi

dvips :
	dvips -o smurp_resume.ps smurp_resume.dvi
	dvips -o smurp_resume_berlin_visa_2017.ps smurp_resume_berlin_visa_2017.dvi

test : dvips gv

txt : dvips
	ps2ascii smurp_resume.ps > smurp_resume.txt

html : smurp_resume.tex
	pandoc -s smurp_resume.tex -o smurp_resume.html

gv :	ps
	gv smurp_resume.ps

xdvi : dvi
	xdvi smurp_resume.dvi

clean :
	rm -f dvi

push :
	git push

docx :
	pandoc -s smurp_resume.tex -o smurp_resume.docx
