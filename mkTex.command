#!/bin/bash





MAINTEXFILE="main"

function removeExt() {
	find . -iname "*.$1" -print0 | xargs -0 rm -rf
}

function clean {
	echo "Cleaning up..."
	removeExt "aux"
	removeExt "bbl"
	removeExt "log"
	removeExt "glg"
	removeExt "blg"
	removeExt "toc"
	removeExt "out"
	removeExt "idx"
	removeExt "ilg"
	removeExt "ind"
	removeExt "lof"
	removeExt "lol"
}


if [ -z $1 ]; then
	# No parameter provided. Assume that this script has been executed as a submodule of a LaTeX project. Navigate to that root and take first best .tex
	pushd ..
	MAINTEXFILE="$(ls *.tex | sort -n | head -1)"
else
	MAINTEXFILE="$1"
fi
if [ -z "$MAINTEXFILE" ]; then
	echo "No .tex file found, terminating"
	exit
fi
echo "Found .tex file $MAINTEXFILE"
exit

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

if [ -z $1 ]; then
	popd
fi
