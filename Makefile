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

# Command to run Pandoc in a Docker container, mounting a Docker volume in order
# to allow access to files in the current directories through relative paths.
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

# Generate an HTML 5 document from a LaTeX document and a generic HTML header
# that specifies formatting options like the default typeface style.

%.html : %.tex include/html
	$(pandoc) \
	--include-in-header=$(word 2,$^) \
	--from=latex --to=html5 --output=$@ $<

# Generate a PDF document from a LaTeX document and a generic LaTeX header that
# specifies formatting options like the margins and default typeface style.

%.pdf : %.tex include/tex
	$(pandoc) \
	--include-in-header=$(word 2,$^) \
	--from=latex --output=$@ $<

# Generate a LaTeX document from an intermediate Markdown file.

%.tex : %.munged.md
	$(pandoc) \
	--from=markdown --to=latex --output=$@ $<

# Generate an intermediate Markdown document for processing into a LaTeX
# document, transforming the ASCII representations " - " and "--" of en and em
# dashes, respectively, into the "--" and "---" expected by LaTeX.

%.munged.md : %.md
	sed -E -e 's/\b--\b/---/g;s/\b - \b/--/g' $< > $@
