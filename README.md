## pllua - Google Protocol Buffer Decoder for Lua

This project is intended as a workbench for decoding wire-transcribed Google Protocol Buffer (Version 2 & 3) messages.

### What it does:

* decodes flat messages - i.e. no repeating or containing fields (aside from strings)
* performs low-level decoding only - i.e., it does not attempt to match fields with their original definitions in the relevant .proto file.

### To demonstrate:

* separately generate a wire-encoded message file (see cpp folder for examples)
* modify main.lua to point to this file
* lua main.lua
* the program will output decoded fields and where possible potential conversions to their original form

### Compatibility:

This code should be compatible with Lua versions: 5.1; 5.2; 5.3 and should even run under LuaJIT.

It should be noted that WireShark plugins are run using a Lua 5.2 interpreter, so keep this in mind when making modifications.

### To Come:

* Proper repeating field support.