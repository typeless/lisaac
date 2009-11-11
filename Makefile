#                   This file is part of Lisaac compiler.
#                     http://isaacproject.u-strasbg.fr/
#                    LSIIT - ULP - CNRS - INRIA - FRANCE
#
#   This program is free software: you can redistribute it and/or modify    
#   it under the terms of the GNU General Public License as published by    
#   the Free Software Foundation, either version 3 of the License, or       
#   (at your option) any later version.                                    
#                                                                           
#   This program is distributed in the hope that it will be useful,         
#   but WITHOUT ANY WARRANTY; without even the implied warranty of          
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           
#   GNU General Public License for more details.                            
#                                                                           
#   You should have received a copy of the GNU General Public License       
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.   
#
# Available targets:
# ==================
#  - all                   Starts the installer in automatic mode--use it if
#  you know the installer is smart enough to compute default values, and those
#  values suit your needs. This option is used in order to install lisaac in a
#  non-userland way.
#
#  - user                  Starts the installer in userland interactive mode
#
#  - install               Copy all files in a proper place (non-userland)
#
#  - clean                 Cleans the installation (non-userland)
#
# In short:
# =========
#  Use : make interactive_userland     for a userland installation
#  Use : make & make install(as root)  for a full system installation
#  Use : make clean(as root)           to clean up a non-userland installation
#
# TODO:
# =====
#  - maybe use /etc/ instead of /usr/lib/lisaac four the compilation options
#  - do a /usr/share/menu/lisaac ?
#  - do a /usr/share/doc-base/lisaac ?
#
# Comments:
# =========
#  - use default path.h or bin/path.h if userland or not
#  - move binaries to /usr/bin/
#  - move libraries to /usr/lib/lisaac/
#  - move documentation to /usr/share/doc/lisaac/
#  - move manpages to /usr/share/man/man1/
#  - if you want to generate the documentation
#    shorter -r -f html lib -o $(LIB)$(HTML)
#
# Bug reports:
# ============
#  bug tracker system: https://gna.org/bugs/?func=additem&group=isaac
#  mail to: Xavier Oswald <x.oswald@free.fr>

PROJECT=lisaac
VERSION_FULL=0.4.0
DIST_SRC=\
	Makefile \
	COPYING \
	Changelog \
	Not_yet_implemented \
	README \
	TODO \
	install_lisaac.c \
	install_lisaac.li \
	make.lip \
	bin \
	editor \
	example \
	lib \
	lib_os \
	manpage \
	shorter \
	src \
	tests

PREFIX=/usr/local
MAN=$(PREFIX)/share/man/man1
DOC=$(PREFIX)/share/doc/lisaac
LIB=$(PREFIX)/share/lisaac
BIN=$(PREFIX)/bin
HTML=/html
DESTDIR?=

#CC=gcc
CFLAGS=-O3

# do not change anything after this point
DIST_NAME=$(PROJECT)-$(VERSION_FULL)
export LISAAC_DIRECTORY=..


help:
	@echo "----------------------------------------------------------------"
	@echo "--               Lisaac IS An Advanced Compiler               --"
	@echo "--            LORIA - LSIIT - ULP - CNRS - FRANCE             --"
	@echo "--         Benoit SONNTAG - sonntag@icps.u-strasbg.fr         --"
	@echo "--                   http://www.lisaac.org/                   --"
	@echo "----------------------------------------------------------------"
	@echo "  make help      - display this help message"
	@echo ""
	@echo ""
	@echo "Quick installation:"
	@echo ""
	@echo "  make user      - compile the installer and run it"
	@echo ""
	@echo "For packagers:"
	@echo ""
	@echo "  make install   - install everything"
	@echo "  make uninstall - uninstall everything"
	@echo "  make dist      - create a package with the sources only"
	@echo "  make distclean - clean the source directory"
	@echo ""
	@echo "For developpers:"
	@echo ""
	@echo "  make all       - compile the compiler, the shorter and the"
	@echo "                   documentation"
	@echo "  make doc       - create documentation for the library"
	@echo "  make bootstrap - bootstrap the compiler"
	@echo "  make check     - check the bootstrap (probably broken)"
	@echo "  make clean     - clean the source directory"
	@echo ""

all: bin/lisaac bin/shorter doc

.PHONY: all bootstrap check doc user install uninstall clean dist distclean help

bootstrap/path.h:
	mkdir bootstrap
	@echo "#define LISAAC_DIRECTORY \"..\"" > bootstrap/path.h

bootstrap/lisaac_pre: bin/lisaac bootstrap/path.h
	cd bootstrap && ../bin/lisaac ../src/make.lip ../src/lisaac -no_debug -boost -gcc "-o lisaac_pre"

bootstrap/lisaac: bootstrap/lisaac_pre
	cd bootstrap && ./lisaac_pre ../src/make.lip ../src/lisaac -no_debug -boost

bootstrap: src bootstrap/lisaac

check: bootstrap
	diff -s bootstrap/lisaac bootstrap/lisaac_pre
	diff -s bin/lisaac bootstrap/lisaac

bin/path.h:
	@echo "#define LISAAC_DIRECTORY \"$(LIB)\"" > $@

path.h src/path.h:
	@echo "#define LISAAC_DIRECTORY \"`pwd`\"" > $@

bin/lisaac: bin/lisaac.c bin/path.h
	$(CC) $(CFLAGS) $< -o $@ -lm -fomit-frame-pointer

bin/shorter: bin/lisaac bin/path.h
	cd bin && ./lisaac ../src/make.lip -shorter -boost

doc: doc/html
doc/html: bin/shorter lib
	mkdir -p doc/html
	cd doc && ../bin/shorter -d -f belinda ../lib -o html 

user: install_lisaac.c
	@echo "- Lisaac compiler installation For Unix / Linux / Windows -"
	@echo "Please wait..."
	$(CC) $(CFLAGS) install_lisaac.c -o install_lisaac
	@echo "- please run ./install_lisaac to finish the installation"
	./install_lisaac

install: bin/lisaac bin/shorter
	mkdir -p $(DESTDIR)$(LIB) 
	mkdir -p $(DESTDIR)$(BIN)
	mkdir -p $(DESTDIR)$(MAN)
	mkdir -p $(DESTDIR)$(DOC)$(HTML)
	cp bin/lisaac  $(DESTDIR)$(BIN) 
	cp bin/shorter  $(DESTDIR)$(BIN)
	cp make.lip  $(DESTDIR)$(LIB)
	cp -rf lib/  $(DESTDIR)$(LIB)
	cp -rf lib_os/  $(DESTDIR)$(LIB)
	cp -rf doc/html/ $(DESTDIR)$(DOC)$(HTML)
	cp -rf shorter/  $(DESTDIR)$(LIB)
	cp -rf manpage/*.gz  $(DESTDIR)$(MAN)

uninstall:
	-rm -rf $(DESTDIR)$(BIN)/lisaac
	-rm -rf $(DESTDIR)$(BIN)/shorter
	-rm -rf $(DESTDIR)$(LIB)
	-rm -rf $(DESTDIR)$(DOC)
	-rm -rf $(DESTDIR)$(MAN)/lisaac.1.gz
	-rm -rf $(DESTDIR)$(MAN)/shorter.1.gz

clean:
	-rm -rf bootstrap
	-rm -f bin/lisaac
	-rm -f bin/shorter bin/shorter.c
	-rm -rf doc
	find . -name "*.orig" -o -name "*.BACKUP.*" -o -name "*.BASE.*" -o -name "*.LOCAL.*" -o -name "*.REMOTE.*" | xargs rm

dist: clean
	if ! test -d $(DIST_NAME) ; then mkdir $(DIST_NAME) ; fi
	cp -rf $(DIST_SRC) $(DIST_NAME)
	find $(DIST_NAME) \( -name .svn -o -name .git -o -name CVS -o -name .cvsignore -o -name *.jar \) -print0 | xargs -0 /bin/rm -rf
	tar -cjf $(DIST_NAME).tar.bz2 $(DIST_NAME)
	/bin/rm -rf $(DIST_NAME)

distclean: clean



