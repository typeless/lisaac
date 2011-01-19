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

export LISAAC_DIRECTORY=$(shell pwd)

DIST_PRJ=lisaac
DIST_VER=0.4.0
DIST_NAME=$(DIST_PRJ)-$(DIST_VER)
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

CC=gcc
CFLAGS=-O2

default: user
	@echo "###########################################################"
	@echo "##                                                       ##"
	@echo "##  See available targets for this Makefile by running:  ##"
	@echo "##                                                       ##"
	@echo "##      make help                                        ##"
	@echo "##                                                       ##"
	@echo "###########################################################"

help:
	@echo "----------------------------------------------------------------"
	@echo "--               Lisaac IS An Advanced Compiler               --"
	@echo "--            LORIA - LSIIT - ULP - CNRS - FRANCE             --"
	@echo "--         Benoit SONNTAG - sonntag@icps.u-strasbg.fr         --"
	@echo "--                   http://www.lisaac.org/                   --"
	@echo "----------------------------------------------------------------"
	@echo "  make help         - display this help message"
	@echo ""
	@echo ""
	@echo "Quick installation:"
	@echo ""
	@echo "  make user         - compile the installer and run it"
	@echo ""
	@echo "For packagers:"
	@echo ""
	@echo "  make install      - install everything"
	@echo "  make uninstall    - uninstall everything"
	@echo "  make dist         - create a package with the sources only"
	@echo "  make distclean    - clean the source directory"
	@echo ""
	@echo "For developpers:"
	@echo ""
	@echo "  make all          - compile the compiler, the shorter and the"
	@echo "                      documentation"
	@echo "  make doc          - create documentation for the library"
	@echo "  make clean        - clean the source directory"
	@echo "  make clean-spaces - clean whitespaces at end of files"
	@echo ""

.PHONY: default all doc clean clean-spaces help user install uninstall dist distclean

all: bin/lisaac bin/shorter doc

#
# User Install
#

user: install_lisaac
	./install_lisaac

install_lisaac: install_lisaac.c

#
# path.h, make.lip
#

bin/path.h:
	@echo "#define LISAAC_DIRECTORY \"$(LIB)\"" > $@

path.h src/path.h:
	@echo "#define LISAAC_DIRECTORY \"`pwd`\"" > $@

#
# Compiler and Shorter
#

bin/lisaac: bin/lisaac.c bin/path.h
	$(CC) $(CFLAGS) $< -o $@ -lm -fomit-frame-pointer

bin/shorter: bin/lisaac make.lip bin/path.h
	cd bin && ./lisaac ../src/make.lip -shorter -boost

#
# Documentation
#

doc: doc/html src/HACKING.html
doc/html: bin/shorter make.lip lib
	mkdir -p doc/html
	cd doc && ../bin/shorter -d -f belinda ../lib -o html 

#
# Installation
#

install: bin/lisaac bin/shorter
	mkdir -p $(DESTDIR)$(LIB) 
	mkdir -p $(DESTDIR)$(BIN)
	mkdir -p $(DESTDIR)$(MAN)
	mkdir -p $(DESTDIR)$(DOC)$(HTML)
	cp bin/lisaac  $(DESTDIR)$(BIN) 
	cp bin/shorter  $(DESTDIR)$(BIN)
	cp make.lip  $(DESTDIR)$(LIB)/make.lip
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

#
# Distribution
#

dist: clean
	if ! test -d $(DIST_NAME) ; then \
		mkdir $(DIST_NAME) ; \
	fi
	cp -rf $(DIST_SRC) $(DIST_NAME)
	find $(DIST_NAME) \( -name .svn -o -name .git -o -name CVS -o -name .cvsignore -o -name "*.jar" \) -print0 | xargs -0 $(RM) -rf
	tar cjf $(DIST_NAME).tar.bz2 $(DIST_NAME)
	-$(RM) -rf $(DIST_NAME)

distclean: clean

#
# Clean
#

clean:
	-$(RM) -rf bootstrap
	-$(RM) -f install_lisaac
	-$(RM) -f lisaac-cov.c lisaac-cov.cov lisaac-cov lisaac-cov.cov.orig
	-$(RM) -f bin/path.h bin/shorter.c bin/shorter bin/lisaac
	-$(RM) -f src/path.h src/shorter.c src/shorter src/lisaac src/lisaac.c
	-$(RM) -f path.h shorter shorter.c lisaac lisaac.c
	-$(RM) -rf doc/html
	-find . \( -name "*.orig" -o -name "*.BACKUP.*" -o -name "*.BASE.*" -o -name "*.LOCAL.*" -o -name "*.REMOTE.*" \) -print0 | xargs -0 $(RM) -rf
	-git clean -fdx

clean-spaces:
	-find . \( -name "*.li" -o -name "*.lip" \) -print0 | xargs -0 sed -i 's/\s*$$//'

src/HACKING.html: src/HACKING Markdown.pl
	$(MARKDOWN_CMDLINE)

### Cucumber tests ###

run-cucumber-wip:
	@echo
	@echo "#########################################"
	@echo "##  Run cucumber for work in progress  ##"
	@echo "#########################################"
	@echo
	cucumber -v -w -f progress -t '~@bootstrap' -t '@wip' features/*.feature

run-cucumber:
	@echo
	@echo "##########################"
	@echo "##  Run cucumber tests  ##"
	@echo "##########################"
	@echo
	cucumber -v -f progress -f rerun -o .cucumber-rerun.txt -t '~@bootstrap' -t '~@wip' features/*.feature

rerun-cucumber:
	@echo
	@echo "##########################################"
	@echo "##  Run cucumber scenarios that failed  ##"
	@echo "##########################################"
	@echo
	@touch .cucumber-rerun.txt
	@if [ -s .cucumber-rerun.txt ]; then \
		cucumber @.cucumber-rerun.txt; \
	fi
	@-$(RM) -f .cucumber-rerun.txt

.PHONY: run-cucumber run-cucumber-wip rerun-cucumber

### Code coverage ###

lisaac-cov: path.h bin/lisaac
	bin/lisaac src/make.lip -compiler -optim -coverage -o "`pwd`/$@"
	cp lisaac-cov.cov lisaac-cov.cov.orig

cov-clean:
	-$(RM) -f lisaac-cov.cov
	-cp lisaac-cov.cov.orig lisaac-cov.cov
cov: lisaac-cov
	-CUKE_LISAAC_NAME=lisaac-cov cucumber -f progress -f rerun -o .cucumber-rerun.txt -t '~@bootstrap' -t '~@wip' features/*.feature
cov-report:
	mkdir -p features/coverage-report
	tools/licoverage --html -o features/coverage-report -e '\.lip$$' -e '/lib/' lisaac-cov.cov

.PHONY: cov cov-clean cov-report

### Markdown ###

MARKDOWN_URL=http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip
MARKDOWN_DIR=Markdown_1.0.1
MARKDOWN_CMDLINE=./Markdown.pl <$< >$@

Markdown.zip:
	wget $(MARKDOWN_URL) -O $@

Markdown.pl:
	$(MAKE) Markdown.zip
	unzip -u -j Markdown.zip $(MARKDOWN_DIR)/$@
	chmod +x $@
	-$(RM) Markdown.zip

%.html: %.mdwn Markdown.pl
	$(MARKDOWN_CMDLINE)

%.html: % Markdown.pl
	$(MARKDOWN_CMDLINE)
