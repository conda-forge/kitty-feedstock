#!/bin/bash
set -ex

export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PREFIX}/share/pkgconfig:${PKG_CONFIG_PATH:-}"
export CFLAGS="${CFLAGS} -I ${PREFIX}/include/freetype2 -I ${PREFIX}/include/harfbuzz"
export GOTOOLCHAIN=local
# conda-forge's shader-slang omits the optional slang-glslang optimizer backend.
export SLANGC="slangc -O0"
$PYTHON setup.py linux-package --prefix="$PREFIX" --update-check-interval=0
# Kitty's own LICENSE is included separately; collect only third-party licenses.
# Chroma's COPYING combines MIT and OFL text, which go-licenses cannot classify.
go-licenses save ./tools/cmd --save_path=library_licenses --ignore=github.com/kovidgoyal/kitty,github.com/alecthomas/chroma/v2
mkdir -p library_licenses/github.com/alecthomas/chroma/v2
cp "$(go list -m -f '{{.Dir}}' github.com/alecthomas/chroma/v2)/COPYING" library_licenses/github.com/alecthomas/chroma/v2/

# add bash completions
mkdir -p "${PREFIX}/share/bash-completion/completions"
"${PREFIX}/bin/kitten" __complete__ setup bash > "${PREFIX}/share/bash-completion/completions/kitty"
