# Support generation of HTML and PDF versions of a single CV in Markdown
# format, using LaTeX as an intermediate format.
#
# Inspired by Mark Szepieniec's project, "The Markdown Resume":
#
# https://mszep.github.io/pandoc_resume/

# Supported targets.

targets = cv.html cv.pdf cv.tex

# Intermediate files that should be deleted automatically after the build.

intermediates = cv.munged.md

# Build all supported targets.

.PHONY : all
all : $(targets)

# Clean up everything, including intermediate files.

.PHONY : clean
clean :
	-rm -f $(targets) $(intermediates)

# Generate an HTML 5 document from a LaTeX document.

%.html : %.tex
	docker run -v $(shell pwd):/source jagregory/pandoc \
	-f latex -t html5 $< -o $@

# Generate a PDF document from a LaTeX document.

%.pdf : %.tex
	docker run -v $(shell pwd):/source jagregory/pandoc \
	-V geometry:margin=1in -f latex $< -o $@

# Generate a LaTeX document from an intermediate Markdown file containing the
# expected representations of en and em dashes.

%.tex : %.munged.md
	docker run -v $(shell pwd):/source jagregory/pandoc \
	-f markdown -t latex $< -o $@

# Generate an intermediate Markdown document for processing into a LaTeX
# document, transforming the ASCII representations " - " and "--" of en and em
# dashes, respectively, into the "--" and "---" expected by LaTeX.

%.munged.md : %.md
	sed -E -e 's/\b--\b/---/g;s/\b - \b/--/g' $< > $@
