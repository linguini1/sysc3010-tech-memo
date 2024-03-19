FILE = memo.md
HTML_FILE = $(patsubst %.md,%.html,$(FILE))
PDF_FILE = $(patsubst %.md,%.pdf,$(FILE))

pdf: $(PDF_FILE)
html: $(HTML_FILE)

$(PDF_FILE): $(HTML_FILE)
	pandoc $^ --pdf-engine=wkhtmltopdf -o $@

$(HTML_FILE):
	grip $(FILE) --export $@

clean:
	@rm $(PDF_FILE)
	@rm $(HTML_FILE)
