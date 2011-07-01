PROGRAM	=	ascii2html
VERSION	=	0.0.1
AUTHOR	=	Qball Cow
COPYRIGHT=	2011-2011
MAIL=		qball@gmpclient.org

SOURCE=		convert.c

DIST=		Makefile\
			COPYING\
			README

PREFIX?=	~/.local/
PKG_CONFIG= 	glib-2.0 gobject-2.0

CFLAGS=		-Wall -Werror -O3
LIBS=
QUIET=		@

#DO NOT EDIT BELOW THIS LINE
MAKEFLAGS	= --no-print-directory
BOLD="\\033[1m"
RESET="\\033[0m"

define print
@{\
	echo "$(1)";\
};
endef

PC_CFLAGS=$(shell pkg-config --silence-errors --cflags $(PKG_CONFIG))
PC_LIBS=$(shell pkg-config --silence-errors --libs $(PKG_CONFIG))
EMPTY=

ifeq ($(PC_CFLAGS), $(EMPTY))
$(error "failed to find one or more packages: '$(PKG_CONFIG)');
endif


DIST_FILE=$(PROGRAM)-$(VERSION).tar.xz
CFLAGS+= -g -std=c99 -D_XOPEN_SOURCE
CFLAGS+=$(PC_CFLAGS)
LIBS+=$(PC_LIBS)
CFLAGS+=-DVERSION="\"$(VERSION)\"" -DPACKAGE="\"$(PROGRAM)\""
CFLAGS+=-DMAIL="\"$(MAIL)\"" -DAUTHOR="\"$(AUTHOR)\""
CFLAGS+=-DCOPYRIGHT="\"$(COPYRIGHT)\""

all: $(PROGRAM)

$(PROGRAM): $(SOURCE) | $(DIST)
	$(call print,"$(BOLD)Compile:$(RESET)\\t\\t$^ into $(PROGRAM)")
	$(QUIET)$(CC) $(LIBS) $(CFLAGS) -o $@ $^

clean:
	$(call print,"$(BOLD)Clean source directory$(RESET)")
	$(QUIET)-rm -f $(PROGRAM) $(DIST_FILE)

#Install
install: $(PROGRAM)
	$(call print,"$(BOLD)Installing:$(RESET)\\t\\t$^ to $(PREFIX)/bin/")
	$(QUIET)install $(PROGRAM) $(PREFIX)"/bin/"



dist: $(DIST_FILE)
$(DIST_FILE): $(DIST) $(SOURCE)
	$(call print,"$(BOLD)Creating dist file$(RESET):\\t$@")
	$(QUIET)tar cfJ $@ $^

.PHONY: test
test: $(PROGRAM)
	@$(MAKE) -C test/ 
