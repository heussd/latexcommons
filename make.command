#!/bin/sh

pushd ..

MAINTEXFILE="main"

function clean {
	echo "Cleaning..."
	find . -iname "*.aux" -print0 | xargs -0 rm -rf
	find . -iname "*.bbl" -print0 | xargs -0 rm -rf
	find . -iname "*.log" -print0 | xargs -0 rm -rf
}

clean

pdflatex $MAINTEXFILE

bibtex $MAINTEXFILE
makeglossaries $MAINTEXFILE
makeindex $MAINTEXFILE

pdflatex $MAINTEXFILE
# Do not continue if pdflatex was unsuccessfull
if [ $? -ne 0 ]; then exit; fi 
pdflatex $MAINTEXFILE
pdflatex $MAINTEXFILE

texcount $MAINTEXFILE.tex -merge -html > countResult.html

clean

popd
