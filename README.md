## pllua - Google Protocol Buffer Decoder for Lua

This pure-Lua project is intended as a workbench for decoding wire-transcribed Google Protocol Buffer (Version 2 & 3) messages.

### Pre-requisites:

One of the following:

* Lua 5.1 with bit32 support
* Lua 5.2
* LuaJit

### What it does:

* decodes flat messages - i.e. no repeating or containing fields (aside from strings and simple byte arrays)
* performs low-level decoding only - i.e., it does not attempt to match fields with their original definitions in the relevant .proto file.

### To demonstrate:

* separately generate a wire-encoded message file (see cpp folder for examples)
* modify main.lua to point to this file
* lua main.lua
* the program will output decoded fields and where possible, potential conversions to their original format.

### Compatibility:

Code is compatible with:

* Lua 5.1
* Lua 5.2
* LuaJIT.

And runs under:

* Linux
* Windows 10
* MacOS X

**Note**: WireShark plugins are run using a Lua 5.2 interpreter, so keep this in mind when making modifications.

### To Come:

* Proper repeating field support.