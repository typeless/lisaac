# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_P=${PN}_$(delete_all_version_separators)

DESCRIPTION="Lisaac is an object prototype based language"
HOMEPAGE="http://isaacproject.u-strasbg.fr/li.html"
SRC_URI="http://isaacproject.u-strasbg.fr/download/${MY_P}.tar.gz"

LICENSE="GLP-3"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~mips ~arm"
IUSE=""

DEPEND=">=sys-devel/gcc-4.0"
RDEPEND=""

S=${WORKDIR}/${PN}

src_compile(){
	emake || die "emake failed"
}

src_install(){
	emake DESTDIR=${D} install || die "install failed"
}
