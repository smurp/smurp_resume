files=smurp_resume.tex smurp_resume.pdf smurp_resume.ps res.sty res-sample2.tex Makefile

help :
	clear ;\
	echo "pdf -- build the pdf file by placing a ps in the watched directory" ;\
	echo "ps -- build a postscript file by running dvips on the dvi file";\
	echo "dvi -- create a dvi file by running latex on the resume";\
	echo "txt -- create a text-only version of the resume" ;\
	echo "print -- print the ps file";\
	echo "acrobat -- view the pdf using acroread";\
	echo "xdvi -- view the dvi using xdvi";\
	echo "distillery -- view the watch directory";\
	echo "fetch -- fetch the created pdf file from the Out directory" ;\
	echo "";

pdf : ps
	ps2pdf smurp_resume.ps smurp_resume.pdf

print : ps
	lpr -Plp0 smurp_resume.ps


dvi : clean
	./pivot_data_structure.py > langauges_formats_apis_and_dtds.tex
	latex smurp_resume.tex && touch dvi

ps : dvi dvips

dvips : 
	dvips -o smurp_resume.ps smurp_resume.dvi

test : dvips gv

txt : dvips
	ps2ascii smurp_resume.ps > smurp_resume.txt

gv :	ps
	gv smurp_resume.ps

distillery :
	ls -alg /EbD/temp/convert_to_pdf/Out

acrobat :
	acroread /EbD/temp/convert_to_pdf/Out/smurp_resume.pdf

xdvi : dvi
	xdvi smurp_resume.dvi

clean : 
	rm -f dvi 

fetch :
	cp /EbD/temp/convert_to_pdf/Out/smurp_resume.pdf .

backup :
	cp ${files} /obster_home/smurp/Library/Resume/
