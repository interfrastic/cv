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
#
# Note that we use $(shell pwd) instead of the more efficient $(CURDIR) for
# compatibility with the Windows Git Bash environment; this formulation
# produces an absolute path without a colon after drive the letter, preventing
# errors like this:
#
# docker: Error response from daemon: invalid mode: /source.

pandoc := docker run --volume=$(shell pwd):/source jagregory/pandoc

# Build all supported targets.

.PHONY : all
all : $(targets)

# Clean up everything, including intermediate files.

.PHONY : clean
clean :
	-rm -f $(targets) $(intermediates)

# Generate an HTML 5 document from a LaTeX document.

cv.html : cv.tex include/header.html
	$(pandoc) \
	--include-in-header=include/header.html \
	--from=latex --to=html5 --output=$@ $<

# Generate a PDF document from a LaTeX document.

cv.pdf : cv.tex include/header.tex
	$(pandoc) \
	--include-in-header=include/header.tex \
	--from=latex --output=$@ $<

# Generate a LaTeX document from an intermediate Markdown file containing the
# expected representations of en and em dashes.

cv.tex : cv.munged.md
	$(pandoc) \
	--from=markdown --to=latex --output=$@ $<

# Generate an intermediate Markdown document for processing into a LaTeX
# document, transforming the ASCII representations " - " and "--" of en and em
# dashes, respectively, into the "--" and "---" expected by LaTeX.

cv.munged.md : cv.md
	sed -E -e 's/\b--\b/---/g;s/\b - \b/--/g' $< > $@
