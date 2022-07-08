-- pblow - low level protobuf decoding for protobuf 2/3 standards

local status, m_bit = pcall( require, "bit32")
if not status then
    m_bit = require( "bit")     -- Lua 5.1
end

local m_u = require( "utils")


local PBLOW = {}



local PB_PRIMITIVES = {
    VARINT              = 0,        -- int32, int64, uint32, uint64, sint32, sint64, bool, enum
    BIT64               = 1,        -- fixed64, sfixed64, double
    LENGTH_DELIMITED    = 2,        -- string, bytes, embedded messages, packed repeated fields
    BIT32               = 5         -- fixed32, sfixed32, float
}


PBLOW.splitKey = function( key)
    local fieldNo = m_bit.rshift( key, 3)
    local fieldType = m_bit.band( key, 0x07)
    return fieldNo, fieldType
end

PBLOW.evaluateVarint = function( chunk)
    local num = 0
    for idx = #chunk, 1, -1 do
        num = m_bit.lshift( num, 7)
        num = m_bit.bor( num, m_bit.band( chunk[idx], 0x7f))
    end
    return num
end

PBLOW.decodeVarint = function(bytes, startPos)
    local chunkEnd = startPos
    repeat
        if bytes[chunkEnd] < 0x80 then
            break
        end
        chunkEnd = chunkEnd + 1
    until false
    local chunk = {m_u.unpack( bytes, startPos, chunkEnd)}
    chunkEnd = chunkEnd + 1
    return chunkEnd, chunk
end


PBLOW.decode64Bit = function( bytes, startPos)
    local chunkEnd = startPos + 8 - 1
    local chunk = {m_u.unpack( bytes, startPos, chunkEnd)}
    chunkEnd = chunkEnd + 1
    return chunkEnd, chunk
end


PBLOW.decodeLengthDelimited = function( bytes, startPos)
    local keyChunk
    startPos, keyChunk = PBLOW.decodeVarint( bytes, startPos)
    local length = PBLOW.evaluateVarint( keyChunk)
    local chunkEnd = startPos + length - 1
    local chunk = {m_u.unpack( bytes, startPos, chunkEnd)}
    chunkEnd = chunkEnd + 1
    return chunkEnd, chunk
end


PBLOW.decode32Bit = function( bytes, startPos)
    local chunkEnd = startPos + 4 - 1
    local chunk = {m_u.unpack( bytes, startPos, chunkEnd)}
    chunkEnd = chunkEnd + 1
    return chunkEnd, chunk
end


PBLOW.zigZagToSInt = function( num)
    local intNum = math.floor( num)
    local sint = math.floor( m_bit.rshift( intNum, 1)) + 1
    sint = sint * (m_bit.band( intNum, 1) * -1)
    return sint
end


PBLOW.convertVarint = function( chunk)
    -- int32, int64, uint32, uint64, sint32, sint64, bool, enum
    local converted = {}
    local num = PBLOW.evaluateVarint( chunk)
    local absNum = math.abs( num)
    if (absNum >= -0x80000000) and (absNum <= 0x7fffffff) then
        converted.int32  = num
        converted.sint32 = PBLOW.zigZagToSInt( num)
    end
    converted.int64  = num
    if num >= 0 then
        if math.abs( num) < 0x7fffffff then
            converted.uint32 = num
        end
        converted.uint64 = num
        converted.enum   = num
    end
    converted.sint64 = PBLOW.zigZagToSInt( num)
    converted.bool = (num ~= 0)
    return converted
end

PBLOW.convert64Bit = function( chunk)
    -- fixed64, sfixed64, double
    local converted = {}
    converted.fixed64 = m_u.bytesToFixed64( chunk)
    converted.sfixed64 = m_u.bytesToSFixed64( chunk)
    converted.double = m_u.bytesToDouble( chunk)
    return converted
end

PBLOW.convertLengthDelimited = function( chunk)
    -- string, bytes, embedded messages, packed repeated fields
    local converted = {}
    local str = ""
    local fail = false
    for _,chr in ipairs( chunk) do
        if m_u.isprint( chr) then
            str = str .. string.char( chr)
        else
            fail = true
            break
        end
    end
    if not fail then
        converted.string = str
    end
    return converted
end

PBLOW.convert32Bit = function( chunk)
    -- fixed32, sfixed32, float
    local converted = {}
    converted.fixed32 = m_u.bytesToFixed32( chunk)
    converted.sfixed64 = m_u.bytesToSFixed32( chunk)
    converted.float = m_u.bytesToFloat32( chunk)
    return converted
end

PBLOW.CONVERTER = {
    [PB_PRIMITIVES.VARINT]           = PBLOW.convertVarint,
    [PB_PRIMITIVES.BIT64]            = PBLOW.convert64Bit,
    [PB_PRIMITIVES.LENGTH_DELIMITED] = PBLOW.convertLengthDelimited,
    [PB_PRIMITIVES.BIT32]            = PBLOW.convert32Bit,
}


PBLOW.DECODER = {
    [PB_PRIMITIVES.VARINT]           = PBLOW.decodeVarint,
    [PB_PRIMITIVES.BIT64]            = PBLOW.decode64Bit,
    [PB_PRIMITIVES.LENGTH_DELIMITED] = PBLOW.decodeLengthDelimited,
    [PB_PRIMITIVES.BIT32]            = PBLOW.decode32Bit,
}


PBLOW.grabChunk = function( bytes, startPos, level)
    local keyChunk
    startPos, keyChunk = PBLOW.DECODER[PB_PRIMITIVES.VARINT]( bytes, startPos)
    local key = PBLOW.evaluateVarint( keyChunk)
    local fieldNo, fieldType = PBLOW.splitKey( key)
    local nextChunk, chunk = PBLOW.DECODER[fieldType](bytes, startPos)
    return nextChunk, fieldNo, fieldType, chunk, level
end

PBLOW.decodeBuffer = function( bytes)
    local thisPos = 1
    local nextPos = 1
    local level = 0
    local chunk
    local fieldNo, fieldType
    local msg = {}
    repeat
        thisPos = nextPos
        nextPos, fieldNo, fieldType, chunk, level = PBLOW.grabChunk( bytes, thisPos, level)
        local newField = {chunk=chunk, fieldType=fieldType}
        newField.converted = PBLOW.CONVERTER[fieldType]( chunk)
        msg[fieldNo] = newField
    until nextPos > #bytes
    return msg
end

return PBLOW
