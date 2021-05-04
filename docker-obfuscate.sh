#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

docker run --rm -i -t -e HOST_UID="$(id -u)" -v "$(pwd):/opt" clank-plugins-lua
