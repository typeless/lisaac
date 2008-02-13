# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator elisp-common

MY_P=${PN}_$(delete_all_version_separators)

DESCRIPTION="Lisaac is an object prototype based language"
HOMEPAGE="http://isaacproject.u-strasbg.fr/li.html"
SRC_URI="http://isaacproject.u-strasbg.fr/download/${MY_P}.tar.gz"

LICENSE="GLP-3"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~mips ~arm"
IUSE="vim kate examples"

DEPEND=">=sys-devel/gcc-4.0
		vim? (app-editors/vim)
		emacs? (virtual/emacs)
		kate? (kde-base/kate)"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}
SITEFILE=50${PN}-gentoo.el

src_compile(){

	emake || die "emake failed"

# the emacs plugin is broken for the moment, so it's better to its installation
#	if use emacs; then
#		elisp-compile editor/emacs/lisaac-mode.el || die
#	fi
}

src_install(){
	emake DESTDIR=${D} install || die "install failed"

	if use vim; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins editor/vim/syntax/lisaac.vim
		insinto /usr/share/vim/vimfiles/indent/
		doins editor/vim/indent/lisaac.vim
	fi

#	if use emacs; then
#		elisp-install ${PN} editor/emacs/*.{el,elc} || die
#		elisp-site-file-install ${FILESDIR}/${SITEFILE} || die
#	fi

	if use kate; then
		insinto /usr/share/apps/katepart/syntax/
		doins editor/kate/lisaac_v2.xml
	fi

	if use examples; then
		dodir /usr/share/${PN}/
		cp -r example ${D}/usr/share/${PN}/examples
	fi
}

pkg_postinst(){
	if use vim; then
		einfo "Add the following line to your vimrc if you want" 
		einfo "to enable the lisaac support :"
		einfo
		einfo "au BufNewFile,BufRead *.li setf lisaac"
	fi

#	use emacs && elisp-site-regen
}

#pkg_postrm(){
#	use emacs && elisp-site-regen
#}
