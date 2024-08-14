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

install:
	@mkdir -p $(BINDIR)

	@cp src/dpm $(BINDIR)
	@chmod 755 $(BINDIR)/dpm

	@cp src/dpm-pkg $(BINDIR)
	@chmod 755 $(BINDIR)/dpm-pkg

uninstall:
	@rm -f $(BINDIR)/dpm
	@rm -f $(BINDIR)/dpm-pkg
