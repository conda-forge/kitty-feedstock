#!/bin/bash
set -ex

export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PREFIX}/share/pkgconfig:${PKG_CONFIG_PATH:-}"
export CFLAGS="${CFLAGS} -I ${PREFIX}/include/freetype2 -I ${PREFIX}/include/harfbuzz"
export GOTOOLCHAIN=local
$PYTHON setup.py linux-package --prefix="$PREFIX" --update-check-interval=0
go-licenses save ./tools/cmd --save_path=library_licenses

# add bash completions
mkdir -p "${PREFIX}/share/bash-completion/completions"
"${PREFIX}/bin/kitten" completion bash > "${PREFIX}/share/bash-completion/completions/kitty"
