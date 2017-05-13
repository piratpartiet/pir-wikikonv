# pir-wikikonv.git/Makefile
# File ID: 0ea43224-367d-11e7-a2b1-db5caa6d21d3

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

.PHONY: test
test:
	cmark --version | grep -q CommonMark

.PHONY: view
view: README.html
	lynx README.html
