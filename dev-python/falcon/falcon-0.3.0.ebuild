# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A supersonic micro-framework for building cloud APIs"
HOMEPAGE="http://falconframework.org/ https://pypi.python.org/pypi/falcon"
SRC_URI="https://github.com/falconry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cython test"

RDEPEND=">=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	dev-python/mimeparse[${PYTHON_USEDEP}]
	cython? (
	dev-python/cython[$(python_gen_usedep python{2_7,3_3,3_4})] )"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
	dev-python/cython[$(python_gen_usedep python{2_7,3_3,3_4})]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}] )"

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}

src_prepare() {
	if ! use cython; then
		sed -i -e 's/if CYTHON:/if False:/' setup.py \
			|| die 'sed failed.'
	fi

	# fix tests installation : potential file collision
	sed -e 's@^where = tests@where = falcon/tests@g' -i setup.cfg || die
	mv tests falcon/
}
