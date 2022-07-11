## pllua - Google Protocol Buffer Decoder For Lua

This pure-Lua project is intended as a workbench for decoding wire-transcribed Google Protocol Buffer (Version 2 & 3) messages.

### Pre-Requisites:

One of the following:

* Lua 5.1 with bit32 support
* Lua 5.2
* LuaJit

### What It Does:

* decodes simple flat messages - i.e. no repeating or containing fields (aside from strings and simple byte arrays)
* performs low-level decoding only - i.e., it does not attempt to match fields with their original definitions in a relevant .proto file.

### To Demonstrate:

* separately generate a wire-encoded message file (see cpp folder for examples)
* modify main.lua to point to this file
* lua main.lua
* the program will output decoded fields and where possible, speculative conversions to their original format.

### Compatibility:

Code is compatible with:

* Lua 5.1
* Lua 5.2
* LuaJIT

And runs under:

* Linux
* Windows 10
* MacOS X

**Note**: WireShark plugins are run using a Lua 5.2 interpreter, so keep this in mind when making modifications.

### What It Won't Do:

It won't be capable of decoding packed repeating fields because there simply isn't enough information in the encoded stream to do so.  The only way to decode repeating fields is by knowing the format in the original .proto file.  From the Google documentation ([https://developers.google.com/protocol-buffers/docs/encoding#types](url)):


```
22        // key (field number 4, wire type 2)
06        // payload size (6 bytes)
03        // first element (varint 3)
8E 02     // second element (varint 270)
9E A7 05  // third element (varint 86942)

```

Note that it's assumed in this case that the repeating fields are varint encoded numbers, but there's nothing in the encoding itself to say so.  You can only know these are varints from the original .proto specification.

### To Come:

Friendlier means of interacting with pblow for a client to decode repeating fields.
