FILE = memo.md
HTML_FILE = $(patsubst %.md,%.html,$(FILE))
PDF_FILE = $(patsubst %.md,%.pdf,$(FILE))

pdf:
	pandoc $(FILE) > $(HTML_FILE)
	pandoc $(HTML_FILE) -o $(PDF_FILE)
	@rm $(HTML_FILE)
