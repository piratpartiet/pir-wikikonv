# pir-wikikonv.git/Makefile
# File ID: 0ea43224-367d-11e7-a2b1-db5caa6d21d3

DBFILE1 = $(HOME)/annex/pir-backup/web/postgres/2017-02-06.pg_dumpall.gz

.PHONY: default
default: README.html

README.html: README.md
	printf '<html>\n<head>\n' >README.html
	printf '<meta http-equiv="Content-Type" ' >>README.html
	printf 'content="text/html; charset=UTF-8" />\n' >>README.html
	printf '<title>README</title>\n' >>README.html
	printf '</head>\n<body>\n' >>README.html
	cmark -t html README.md >>README.html
	printf '</body>\n</html>\n' >>README.html

.PHONY: clean
clean:
	rm -f README.html
	cd t && $(MAKE) clean

.PHONY: edit
edit:
	$(EDITOR) $$(git ls-files)

.PHONY: test
test:
	cd t && $(MAKE) test
	test -e $(DBFILE1)
	test "$$(sha256sum $(DBFILE1) | head -c 12)" = "52ac43fb4c0f"

.PHONY: view
view: README.html
	lynx README.html
