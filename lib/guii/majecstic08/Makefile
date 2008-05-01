### Exemple de Makefile pour un article de revue ou de conférence
### Ce makefile force l'exécution d'au moins 3 passages de Latex
### et appelle bibtex pour résoudre les références, éventuellement
### en avant de sections, tableaux ou bibliographiques.
### Certains articles peuvent nécessiter moins de passsages,
### d'autres davantage : à adapter.

### Indiquer ci-dessous le nom du fichier qui contient l'article
ARTICLE   = doc-article-hermes.ltx

### Indiquer les noms des fichiers .eps éventuels
FIGURES   = 

### Indiquer le ou les fichiers .bbl utilisés.
### Si ce fichier a le même nom que l'article sauf le suffixe,
### laisser la définition suivante.
BBL       =  $(ARTICLE:.ltx=.bbl)

### PROGS

### Définir le nom de chemin du répertoire texmf qui contient
### la distribution complète de latex/tex/bibtex ...
### Ce qui suit n'est qu'une suggestion pour quelques environnements

# pour OSF/1
#TEXMF = /usr/local/share/texmf

# pour Windows / MikTeX / Cygwin (à adapter)
# TEXMF = /cygdrive/c/MikTeX/Texmf 

# Pour Linux
TEXMF=  /usr/share/texmf

### Ce qui suit devrait rester tel que dans la plupqrt des cas ##################

HERMESPATH  = .:$(TEXMF)//
TEXINPUTS   = TEXINPUTS=$(HERMESPATH)
BIBINPUTS   = BIBINPUTS=$(HERMESPATH) BSTINPUTS=$(HERMESPATH)

LATEX       = $(TEXINPUTS) latex
BIBTEX      = $(BIBINPUTS) bibtex

### Contenu de l'article

LTX       = doc-article-hermes.ltx
PS        = $(LTX:.ltx=.ps)
BBL       = $(LTX:.ltx=.bbl)

### RULES

.SUFFIXES:
.SUFFIXES: .ps .dvi .bbl .aux .ltx

.aux.bbl: ; $(BIBTEX) $*

### Paramètres de l'imprimante utilisée (cela peut être mis en commentaires ou adapté)

DPI         = 600      # résolution de l'imprimante
OFFSET      = 0mm,0mm  # offset de l'imprimante
PAGEFORMAT  = a4       # Format du papier
DVIFLAGS    = -D $(DPI) -t $(PAGEFORMAT) -O $(OFFSET)

### TARGETS

DVI0      = $(ARTICLE:.ltx=.dvi0)
DVI1      = $(ARTICLE:.ltx=.dvi1)
DVI       = $(ARTICLE:.ltx=.dvi)

BLG       = $(BBL:.bbl=.blg)

AUX       = $(ARTICLE:.ltx=.aux)
LOG       = $(ARTICLE:.ltx=.log)
LOGS      = $(AUX) $(BLG) $(LOG)

PS        = $(ARTICLE:.ltx=.ps)

all: $(PS)

$(DVI0) : $(ARTICLE) $(FIGURES)
	@ echo "===> $(DVI0) et 1ères références en avant (.aux)"
	$(LATEX) $(ARTICLE)
	mv $(DVI) $(DVI0)

$(BBL)  : $(DVI0)
	@ for f in $(BBL) ; \
	do F=`basename $$f .bbl` ; \
		echo "===> $$F.bbl"; \
		$(BIBTEX) $$F ; \
	done

$(DVI1) : $(DVI0) $(BBL)
	@ echo "===> $(DVI1), $(BBL), élimination des références en avant"
	$(LATEX) $(ARTICLE)
	mv $(DVI) $(DVI1)

$(DVI) : $(DVI1)
	@ echo "===> $(DVI) final ..."
	$(LATEX)  $(ARTICLE)

$(PS) : $(DVI)
	@ echo "===> $(PS) final ..."
	dvips $(DVIFLAGS) -o $(PS) $(DVI)

new :
	@ echo "===> recompilation forcée ..."
	$(LATEX)  $(ARTICLE)
	dvips $(DVIFLAGS) -o $(PS) $(DVI)

clean:;
	rm -f \#* *~ $(PS) $(LOGS) $(DVI0) $(DVI1) $(DVI) $(AUX)

veryclean:;
	make clean
	rm -f $(BBL) $(BLG) $(IDX) $(IND) *.bbl *.aux

