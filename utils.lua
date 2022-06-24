-- utils

local status, m_bit = pcall( require, "bit32")
if not status then
    m_bit = require( "bit")     -- Lua 5.1
end


local UTILS = {}


local TWO_TO_EIGHT = (2^8)              -- pre-calcuate this
local TWO_TO_THIRTY_ONE = (2^31)        -- pre-calcuate this


UTILS.tkeys = function( obj)
    local keys = {}
    for k,_ in pairs( obj) do
        if type( k) ~= "number" then
            table.insert( keys, k)
        end
    end
    table.sort( keys)
    return keys
end


UTILS.strToBuf = function( str)
    local bytes = {}
    for idx = 1,#str do
        local chr = str:sub(idx, idx)
        local byte = string.byte( chr)
        table.insert( bytes, byte)
    end
    return bytes
end


UTILS.bufToStr = function( buf)
    local str = ""
    for _,byte in ipairs( buf) do
        str = str .. string.char( byte)
    end
    return str
end


UTILS.isprint = function( char)
    if char >= 0x20 and char <= 0x7f then
        return true
    end
    return false
end

UTILS.sign = function( num)
    if num < 0 then
        return -1
    elseif num > 0 then
        return 1
    end
    return 0
end

UTILS.isMSBSet = function( byte)
    local status = false
    if m_bit.band( byte, 0x80) ~= 0 then
        status = true
    end
    return status
end

UTILS.bytesToFixed64 = function( bytes)
    assert( #bytes == 8)
    local fixed64 = bytes[8]
    fixed64 = (fixed64 * TWO_TO_EIGHT) + bytes[7]
    fixed64 = (fixed64 * TWO_TO_EIGHT) + bytes[6]
    fixed64 = (fixed64 * TWO_TO_EIGHT) + bytes[5]
    fixed64 = (fixed64 * TWO_TO_EIGHT) + bytes[4]
    fixed64 = (fixed64 * TWO_TO_EIGHT) + bytes[3]
    fixed64 = (fixed64 * TWO_TO_EIGHT) + bytes[2]
    fixed64 = (fixed64 * TWO_TO_EIGHT) + bytes[1]
    return fixed64
end

UTILS.bytesToOnesComplement = function( bytes)
    local onesComp = {}
    for idx, byte in ipairs( bytes) do
        onesComp[idx] = m_bit.band( m_bit.bnot( byte), 0xff)
    end
    return onesComp
end

UTILS.bytesToSFixed64 = function( bytes)
    assert( #bytes == 8)
    local sfixed64 = 0
    if not UTILS.isMSBSet( bytes[8]) then
        -- get positive numbers out of the way
        sfixed64 = UTILS.bytesToFixed64( bytes)
    else
        -- all lua numbers are doubles (on a 64-bit system)
        -- this raises precision problems using the normal two's-complement method for 32-bits
        -- so we have to roll our own two's-complement math
        local onesComp = UTILS.bytesToOnesComplement( bytes)
        sfixed64 = m_bit.band(onesComp[8], 0xff)
        sfixed64 = (sfixed64 * TWO_TO_EIGHT) + onesComp[7]
        sfixed64 = (sfixed64 * TWO_TO_EIGHT) + onesComp[6]
        sfixed64 = (sfixed64 * TWO_TO_EIGHT) + onesComp[5]
        sfixed64 = (sfixed64 * TWO_TO_EIGHT) + onesComp[4]
        sfixed64 = (sfixed64 * TWO_TO_EIGHT) + onesComp[3]
        sfixed64 = (sfixed64 * TWO_TO_EIGHT) + onesComp[2]
        sfixed64 = (sfixed64 * TWO_TO_EIGHT) + onesComp[1]
        sfixed64 = -sfixed64 - 1
    end
    return sfixed64
end

UTILS.bytesToFixed32 = function( bytes)
    assert( #bytes == 4)
    local fixed32 = bytes[4]
    fixed32 = (fixed32 * TWO_TO_EIGHT) + bytes[3]
    fixed32 = (fixed32 * TWO_TO_EIGHT) + bytes[2]
    fixed32 = (fixed32 * TWO_TO_EIGHT) + bytes[1]
    return fixed32
end

UTILS.bytesToSFixed32 = function( bytes)
    assert( #bytes == 4)
    local sfixed32 = m_bit.band( bytes[4], 0x7f)
    sfixed32 = (sfixed32 * TWO_TO_EIGHT) + bytes[3]
    sfixed32 = (sfixed32 * TWO_TO_EIGHT) + bytes[2]
    sfixed32 = (sfixed32 * TWO_TO_EIGHT) + bytes[1]
    if UTILS.isMSBSet( bytes[4]) then
        sfixed32 = sfixed32 - TWO_TO_THIRTY_ONE
    end
    return sfixed32
end

UTILS.bytesToFloat32 = function( bytes)
    assert( #bytes == 4)
    local sign = 1
    if m_bit.band( bytes[4], 0x80) ~= 0 then
        sign = -1
    end
    local exponent = m_bit.rshift( bytes[3], 7)
    exponent = m_bit.bor( exponent, m_bit.lshift( m_bit.band( bytes[4], 0x7f), 1))
    local mantissa = m_bit.band( bytes[3], 0x7f)
    mantissa = m_bit.bor( m_bit.lshift( mantissa, 8), bytes[2])
    mantissa = m_bit.bor( m_bit.lshift( mantissa, 8), bytes[1])
    mantissa = (math.ldexp( mantissa, -23) + 1) * sign
    local float32 = math.ldexp( mantissa, exponent - 127)
    return float32
end

UTILS.bytesToDouble = function( bytes)
    assert( #bytes == 8)
    -- NOT IMPLEMENTED - LUA BITOPS ONLY 32-BIT WHICH MAKES MANTISSA CALCULATION A PROBLEM
    local sign = 1
    if m_bit.band( bytes[8], 0x80) ~= 0 then
        sign = -1
    end
    local exponent = m_bit.rshift( bytes[7], 4)
    exponent = m_bit.bor( exponent, m_bit.lshift( m_bit.band( bytes[8], 0x7f), 4))
    local mantissa = m_bit.band( bytes[7], 0x0f)
    mantissa = mantissa * 2^8 + bytes[6]
    mantissa = mantissa * 2^8 + bytes[5]
    mantissa = mantissa * 2^8 + bytes[4]
    mantissa = mantissa * 2^8 + bytes[3]
    mantissa = mantissa * 2^8 + bytes[2]
    mantissa = mantissa * 2^8 + bytes[1]
    mantissa = (math.ldexp( mantissa, -52) + 1) * sign
    local double = math.ldexp( mantissa, exponent - 1023)
    return double
end

return UTILS
