-- utils

local m_b32 = require( "bit32")


local UTILS = {}


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

UTILS.bytesToFloat32 = function( bytes)
    assert( #bytes == 4)
    local sign = 1
    if m_b32.band( bytes[4], 0x80) ~= 0 then
        sign = -1
    end
    local exponent = m_b32.rshift( bytes[3], 7)
    exponent = m_b32.bor( exponent, m_b32.lshift( m_b32.band( bytes[4], 0x7f), 1))
    local mantissa = m_b32.band( bytes[3], 0x7f)
    mantissa = m_b32.bor( m_b32.lshift( mantissa, 8), bytes[2])
    mantissa = m_b32.bor( m_b32.lshift( mantissa, 8), bytes[1])
    mantissa = (math.ldexp( mantissa, -23) + 1) * sign
    local float32 = math.ldexp( mantissa, exponent - 127)
    return float32
end

UTILS.bytesToDouble = function( bytes)
    assert( #bytes == 8)
    -- NOT IMPLEMENTED - LUA BITOPS ONLY 32-BIT WHICH MAKES MANTISSA CALCULATION A PROBLEM
    local sign = 1
    if m_b32.band( bytes[8], 0x80) ~= 0 then
        sign = -1
    end
    local exponent = m_b32.rshift( bytes[7], 4)
    exponent = m_b32.bor( exponent, m_b32.lshift( m_b32.band( bytes[8], 0x7f), 4))
    local mantissa = m_b32.band( bytes[7], 0x0f)
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
