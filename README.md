# Clank Plugins

This repository is dedicated for example Lua plugins written for [Clank](https://github.com/hashsploit/clank).


## Plugins

This directory holds a collection of clank plugins.

- **hello-world** - This is a demo Hello World example plugin.

## Lib

This directory holds facade libraries intended to aid in the development of plugins outside of the clank environment.

## Clank API

Under Construction.

## Obfuscator & Compiler

This repo adds functionality to obfuscate and compile your Lua source plugins into Lua byte-code.

**Note:** Currently the obfuscator does not handle multi-file/require/dofile properly.

### How to use

You can run the obfuscator and compiler by running `./obfuscate.sh` if you have Luac installed.
Or if you have Docker: `./docker-build.sh` and then run `./docker-obfuscate.sh`.
