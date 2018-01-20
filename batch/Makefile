SOURCES_BASE = src/types.bat src/reader.bat src/printer.bat
SOURCES_LISP = src/env.bat src/core.bat
SOURCES = $(SOURCES_BASE) $(SOURCES_LISP)

all:
	true

dist: mal.bat

mal.bat: $(SOURCES) src/stepA_mal.bat
	cat $+ > $@

step0_repl.bat: $(SOURCES) src/step0_repl.bat
	cat $+ > $@

clean:
	rm -f *.bat

.PHONY: stats

stats: $(SOURCES)
	@wc $^
	@printf "%5s %5s %5s %s\n" `grep -E "^[[:space:]]*#|^[[:space:]]*$$" $^ | wc` "[comments/blanks]"
stats-lisp: $(SOURCES_LISP)
	@wc $^
	@printf "%5s %5s %5s %s\n" `grep -E "^[[:space:]]*#|^[[:space:]]*$$" $^ | wc` "[comments/blanks]"
