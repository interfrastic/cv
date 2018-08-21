# Support generation of HTML and PDF versions of a single CV in Markdown
# format, using LaTeX as an intermediate format.
#
# Inspired by Mark Szepieniec's project, "The Markdown Resume":
#
# https://mszep.github.io/pandoc_resume/

# Supported targets.

targets := cv.html cv.pdf cv.tex

# Intermediate files that should be deleted automatically after the build.

intermediates := cv.munged.md

# Docker volume

pandoc := docker run --volume='$(shell pwd):/source' jagregory/pandoc

# Build all supported targets.

.PHONY : all
all : $(targets)

# Clean up everything, including intermediate files.

.PHONY : clean
clean :
	-rm -f $(targets) $(intermediates)

# Generate an HTML 5 document from a LaTeX document.

%.html : %.tex
	$(pandoc) \
	--include-in-header=include/header.html \
	--from=latex --to=html5 --output=$@ $<

# Generate a PDF document from a LaTeX document.

%.pdf : %.tex
	$(pandoc) \
	--variable='geometry:margin=1in' \
	--include-in-header=include/header.tex \
	--from=latex --output=$@ $<

# Generate a LaTeX document from an intermediate Markdown file containing the
# expected representations of en and em dashes.

%.tex : %.munged.md
	$(pandoc) \
	--from=markdown --to=latex --output=$@ $<

# Generate an intermediate Markdown document for processing into a LaTeX
# document, transforming the ASCII representations " - " and "--" of en and em
# dashes, respectively, into the "--" and "---" expected by LaTeX.

%.munged.md : %.md
	sed -E -e 's/\b--\b/---/g;s/\b - \b/--/g' $< > $@
