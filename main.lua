-- pblua - lua protocol buffer decoder test bed
-- Author: Craig McFarlane


local m_p = require( "print")


local PB_TYPES = {
    VARINT              = 0,        -- int32, int64, uint32, uint64, sint32, sint64, bool, enum
    BIT64               = 1,        -- fixed64, sfixed64, double
    LENGTH_DELIMITED    = 2,        -- string, bytes, embedded messages, packed repeated fields
    BIT32               = 5         -- fixed32, sfixed32, float
}


local splitKey = function( key)
    local fieldNo = bit.rshift( bit.band( key, 0xf8), 3)
    local fieldType = bit.band( key, 0x07)
    return fieldNo, fieldType
end

local evaluateVarint = function( chunk)
    local num = 0
    for idx = #chunk, 1, -1 do
        num = bit.lshift( num, 7)
        num = bit.bor( num, bit.band( chunk[idx], 0x7f))
    end
    return num
end

local decodeVarint = function(bytes, startPos)
    local chunkEnd = startPos
    repeat
        if bytes[chunkEnd] < 0x80 then
            break
        end
        chunkEnd = chunkEnd + 1
    until false
    local chunk = {table.unpack( bytes, startPos, chunkEnd)}
    chunkEnd = chunkEnd + 1
    return chunkEnd, chunk
end


local decode64Bit = function( bytes, startPos)
    local chunkEnd = startPos + 8 - 1
    local chunk = {table.unpack( bytes, startPos, chunkEnd)}
    chunkEnd = chunkEnd + 1
    return chunkEnd, chunk
end


local decodeLengthDelimited = function( bytes, startPos)
    local keyChunk
    startPos, keyChunk = decodeVarint( bytes, startPos)
    local length = evaluateVarint( keyChunk)
    local chunkEnd = startPos + length - 1
    local chunk = {table.unpack( bytes, startPos, chunkEnd)}
    chunkEnd = chunkEnd + 1
    return chunkEnd, chunk
end


local decode32Bit = function( bytes, startPos)
    local chunkEnd = startPos + 4 - 1
    local chunk = {table.unpack( bytes, startPos, chunkEnd)}
    chunkEnd = chunkEnd + 1
    return chunkEnd, chunk
end


local DECODER = {
    [PB_TYPES.VARINT]           = decodeVarint,
    [PB_TYPES.BIT64]            = decode64Bit,
    [PB_TYPES.LENGTH_DELIMITED] = decodeLengthDelimited,
    [PB_TYPES.BIT32]            = decode32Bit,
}


local grabChunk = function( bytes, startPos, level)
    local keyChunk
    startPos, keyChunk = DECODER[PB_TYPES.VARINT]( bytes, startPos)
    local key = evaluateVarint( keyChunk)
    local fieldNo, fieldType = splitKey( key)
    local nextChunk, chunk = DECODER[fieldType](bytes, startPos)
    return nextChunk, fieldNo, chunk, level
end


local PROTOBUF_DATA = "ks.data"


print( m_p.sprint( "hello"))
local tab = { a=1, b=2, c=3, d={4, 5, 6}, e={z=123, x=321, y="FRED"}}
tab[1] = 1.2345
tab[2] = { 956, 123}
print( m_p.sprint( "tab: %s", tab))
local inFile = io.open(PROTOBUF_DATA, "rb")
local buffer = inFile:read("*a")
inFile.close()
local bytes = m_p.strToBuf( buffer)
print( m_p.sprint( "buffer: %s", m_p.pbuf( bytes)))
local thisPos = 1
local nextPos = 1
local level = 0
local chunk
local fieldNo
local msg = {}
repeat
    thisPos = nextPos
    nextPos, fieldNo, chunk, level = grabChunk( bytes, thisPos, level)
    msg[fieldNo] = chunk
    local length = nextPos - thisPos
    print( m_p.sprint( "chunk: %s", m_p.pbuf( chunk)))
until thisPos == nextPos

