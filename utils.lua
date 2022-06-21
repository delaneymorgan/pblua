-- utils

local m_b = require( "bit32")


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
    if m_b.band( bytes[4], 0x80) ~= 0 then
        sign = -1
    end
    local exponent = m_b.rshift( bytes[3], 7)
    exponent = m_b.bor( exponent, m_b.lshift( m_b.band( bytes[4], 0x7f), 1))
    local mantissa = m_b.band( bytes[3], 0x7f)
    mantissa = m_b.bor( m_b.lshift( mantissa, 8), bytes[2])
    mantissa = m_b.bor( m_b.lshift( mantissa, 8), bytes[1])
    mantissa = (math.ldexp( mantissa, -23) + 1) * sign
    local float32 = math.ldexp( mantissa, exponent - 127)
    return float32
end

UTILS.bytesToDouble = function( bytes)
    assert( #bytes == 8)
    -- NOT IMPLEMENTED - LUA BITOPS ONLY 32-BIT WHICH MAKES MANTISSA CALCULATION A PROBLEM
    local double
    return double
end

return UTILS
