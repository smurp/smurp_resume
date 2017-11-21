files=smurp_resume.tex smurp_resume.pdf smurp_resume.ps res.sty res-sample2.tex Makefile

help :
	clear ;\
	echo "pdf -- build the pdf file by placing a ps in the watched directory" ;\
	echo "ps -- build a postscript file by running dvips on the dvi file";\
	echo "dvi -- create a dvi file by running latex on the resume";\
	echo "txt -- create a text-only version of the resume" ;\
	echo "docx -- create a Word version of the resume WIP: misses company names" ;\
	echo "print -- print the ps file";\
	echo "xdvi -- view the dvi using xdvi";\
	echo "";

pdf : ps
	ps2pdf smurp_resume.ps smurp_resume.pdf
	ps2pdf smurp_resume_berlin_visa_2017.ps smurp_resume_berlin_visa_2017.pdf

print : ps
	lpr -Plp0 smurp_resume.ps

dvi : clean
	./pivot_data_structure.py > langauges_formats_apis_and_dtds.tex
	latex smurp_resume_berlin_visa_2017.tex && touch dvi
	latex smurp_resume.tex && touch dvi

ps : dvi dvips

dvips :
	dvips -o smurp_resume.ps smurp_resume.dvi
	dvips -o smurp_resume_berlin_visa_2017.ps smurp_resume_berlin_visa_2017.dvi

test : dvips gv

txt : dvips
	ps2ascii smurp_resume.ps > smurp_resume.txt

gv :	ps
	gv smurp_resume.ps

xdvi : dvi
	xdvi smurp_resume.dvi

clean :
	rm -f dvi

backup :
	cp ${files} /obster_home/smurp/Library/Resume/

push :
	git push

docx :
	pandoc -s smurp_resume.tex -o smurp_resume.docx
