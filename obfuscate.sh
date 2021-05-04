#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# Check if java is installed
if ! command -v luac &> /dev/null; then
    echo -e "$(tput bold)$(tput setaf 1)Luac is not installed, please install lua!$(tput sgr0)"
    exit 1
fi

echo -e "Compiling Lua source files using $(luac -v) ..."

rm -rf obfuscated/ >/dev/null 2>&1
mkdir -p obfuscated/
cp -r plugins/* obfuscated/
cd obfuscated/

for f in $(find . -name "*.lua"); do
	echo -e "Processing ${f} ..."
	luac -s -o "${f%.*}.lub" "$f"
	rm -f $f
done

cd ..

if [[ ! -z $HOST_UID ]]; then
	chown -R $HOST_UID:$HOST_UID obfuscated/
fi

# Fix coloring
echo -e "$(tput sgr0)"

