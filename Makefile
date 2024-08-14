# Copyright (C) astral
# See COPYING for more details.

.POSIX:

include config.mk

.SUFFIXES:
.SUFFIXES: .c .o .sh

.c.o:
	$(CC) $(CFLAGS) -o $@ -c $<

.sh:
	cp $< $@
	chmod a+x $@

all: src/dpm src/dpm-pkg

src/dpm: \
	src/dpm.o
	$(CC) $(CFLAGS) -o $@ \
		src/dpm.o \
		$(LDFLAGS)
src/dpm.o: src/dpm.c

src/dpm-pkg: src/dpm-pkg.sh

clean:
	@rm -f src/dpm
	@rm -f src/dpm.o
	@rm -f src/dpm-pkg

	@rm -f dpm-*

install:
	@mkdir -p $(BINDIR)

	@cp src/dpm $(BINDIR)
	@chmod 755 $(BINDIR)/dpm

	@cp src/dpm-pkg $(BINDIR)
	@chmod 755 $(BINDIR)/dpm-pkg

	@mkdir -p $(MANDIR)/man1

	@cp doc/dpm.1 $(MANDIR)/man1
	@chmod 644 $(MANDIR)/man1/dpm.1

	@cp doc/dpm-pkg.1 $(MANDIR)/man1
	@chmod 644 $(MANDIR)/man1/dpm-pkg.1

uninstall:
	@rm -f $(BINDIR)/dpm
	@rm -f $(BINDIR)/dpm-pkg
	@rm -f $(MANDIR)/man1/dpm.1
	@rm -f $(MANDIR)/man1/dpm-pkg.1

dist: clean
	mkdir -p dpm-$(VERSION)
	cp -r Makefile config.mk src doc README COPYING dpm-$(VERSION)
	pax -wx ustar dpm-$(VERSION) > dpm-$(VERSION).tar
	rm -rf dpm-$(VERSION)
	gzip -k dpm-$(VERSION).tar
	xz dpm-$(VERSION).tar
