#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# Check if lua is installed
if ! command -v lua &> /dev/null; then
    echo -e "$(tput bold)$(tput setaf 1)Lua is not installed, please install lua!$(tput sgr0)"
    exit 1
fi

# Check if luac is installed
if ! command -v luac &> /dev/null; then
    echo -e "$(tput bold)$(tput setaf 1)Luac is not installed, please install luac!$(tput sgr0)"
    exit 1
fi

echo -e "--= Clank Lua Plugin Obfuscator and Compiler Tool =--"
echo -e ""
echo -e "Lua obfuscator: LuaSeel 1.2.0"
echo -e "Lua compiler: $(luac -v)"
echo -e ""

rm -rf obfuscated/ >/dev/null 2>&1
mkdir -p obfuscated/
cp -r plugins/* obfuscated/
cd obfuscated/

for source in $(find . -name "*.lua"); do
	echo -e "Processing ${source} ..."
	# Obfuscate
	lua ../lib/obfuscator.lua "${source}" > "${source}.tmp"
	mv "${source}.tmp" "${source}"
	
	# Compile
	binary="${source%.*}.lub"
	luac -s -o "${binary}" "${source}"
	mv "${binary}" "${source}"
done

cd ..

if [[ ! -z $HOST_UID ]]; then
	chown -R $HOST_UID:$HOST_UID obfuscated/
fi
