-- pblua - lua protocol buffer decoder test bed
-- Author: Craig McFarlane


local PB_TYPES = {
    VARINT              = 0,        -- int32, int64, uint32, uint64, sint32, sint64, bool, enum
    BIT64               = 1,        -- fixed64, sfixed64, double
    LENGTH_DELIMITED    = 2,        -- string, bytes, embedded messages, packed repeated fields
    BIT32               = 5         -- fixed32, sfixed32, float
}


local tkeys = function( obj)
    local keys = {}
    for k,_ in pairs( obj) do
        if type( k) ~= "number" then
            table.insert( keys, k)
        end
    end
    table.sort( keys)
    return keys
end


local tprint = nil


local eprint = function( element)
    local str = "nil"
    if element then
        if type( element) == "table" then
            str = tprint( element)
        elseif type( element) == "string" then
            str = '"' .. element .. '"'
        elseif type( element) == "number" then
            str = tostring( element)
        end
    end
    return str
end


tprint = function( obj)
    local str = ""
    if type( obj) ~= "table" then
        return "<not table>"
    end
    -- print dictionary elements
    local keys = tkeys( obj)
    if #keys > 0 then
        str = str .. "{"
        local first = true
        for _,k in ipairs( keys) do
            if not first then
                str = str .. ", "
            end
            first = false
            str = str .. k .. ":" .. eprint( obj[k])
        end
        str = str .. "}"
    end
    -- print array elements
    if #obj > 0 then
        str = str .. "["
        first = true
        for _,v in ipairs( obj) do
            if not first then
                str = str .. ", "
            end
            first = false
            str = str .. eprint( v)
        end
        str = str .. "]"
    end
    return str
end


local sprint = function( fmt, ...)
    local arg = {...}
    local str = fmt
    if #arg > 0 then
        str = string.format( fmt, eprint( unpack( arg)))
    end
    return str
end


local pbuf = function( buf, start, length)
    if not start then
        start = 1
    end
    if not length then
        length = 1000
    end
    local str = ""
    local first = true
    str = "["
    for idx,value in ipairs( buf) do
        if idx >= start then
            if not first then
                str = str .. ", "
            end
            first = false
            str = str .. string.format( "0x%02x", value)
        end
        if (idx - start) > length then
            break
        end
    end
    str = str .. "]"
    return str
end


local strToBuf = function( str)
    local bytes = {}
    for idx = 1,#str do
        local chr = str:sub(idx, idx)
        local byte = string.byte( chr)
        table.insert( bytes, byte)
    end
    return bytes
end


local splitKey = function( key)
    local fieldNo = bit.rshift( bit.band( key, 0xf8), 3)
    local fieldType = bit.band( key, 0x07)
    return fieldNo, fieldType
end


local decodeVarint = function(bytes, startPos)
    local chunkEnd = startPos
    while bytes[chunkEnd] >= 0x80 do
        chunkEnd = chunkEnd + 1
    end
    local chunk = {table.unpack( bytes, startPos, chunkEnd - 1)}
    return chunkEnd, chunk
end


local decode64Bit = function( bytes, startPos)
end


local decodeLengthDelimited = function( bytes, startPos)
    local length = bytes[startPos]
end


local decode32Bit = function( bytes, startPos)
end


local DECODER = {
    [PB_TYPES.VARINT]           = decodeVarint,
    [PB_TYPES.BIT64]            = decode64Bit,
    [PB_TYPES.LENGTH_DELIMITED] = decodeLengthDelimited,
    [PB_TYPES.BIT32]            = decode32Bit,
}


local grabChunk = function( bytes, startPos, level)
    local fieldNo, fieldType = splitKey( bytes[startPos])
    local nextChunk, chunk = DECODER[fieldType](bytes, startPos + 1)
    return nextChunk, chunk, level
end


local PROTOBUF_DATA = "kitchensink.data"


print( sprint( "hello"))
local tab = { a=1, b=2, c=3, d={4, 5, 6}, e={z=123, x=321, y="FRED"}}
tab[1] = 1.2345
tab[2] = { 956, 123}
print( sprint( "tab: %s", tab))
local inFile = io.open(PROTOBUF_DATA, "rb")
local buffer = inFile:read("*a")
inFile.close()
local bytes = strToBuf( buffer)
print( sprint( "buffer: %s", pbuf( bytes)))
local thisPos = 1
local nextPos = 1
local level = 0
repeat
    thisPos = nextPos
    local nextChunk, chunk, level = grabChunk( bytes, thisPos, level)
    local length = nextChunk - thisPos
    print( sprint( "chunk: %s", pbuf( chunk, length)))
until thisPos
 == nextChunk

