#!/bin/bash
set -ex

export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:${PKG_CONFIG_PATH}"
export CFLAGS="${CFLAGS} -I ${PREFIX}/include/freetype2 -I ${PREFIX}/include/harfbuzz -DTIME_WITH_SYS_TIME=1"
$PYTHON setup.py linux-package --prefix=$PREFIX --update-check-interval=0

# add bash completions
mkdir -p "${PREFIX}/share/bash-completion/completions"
"${PREFIX}/bin/kitty" + complete setup bash > "${PREFIX}/share/bash-completion/completions/kitty"
