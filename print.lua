-- print module

local m_u = require( "utils")


local PRINT = {}


PRINT.eprint = function( element)
    local str = "nil"
    if element then
        if type( element) == "table" then
            str = PRINT.tprint( element)
        elseif type( element) == "string" then
            str = '"' .. element .. '"'
        elseif type( element) == "number" then
            str = tostring( element)
        end
    end
    return str
end


PRINT.tprint = function( obj)
    local str = ""
    if type( obj) ~= "table" then
        return "<not table>"
    end
    -- print dictionary elements
    local keys = m_u.tkeys( obj)
    if #keys > 0 then
        str = str .. "{"
        local first = true
        for _,k in ipairs( keys) do
            if not first then
                str = str .. ", "
            end
            first = false
            str = str .. k .. ":" .. PRINT.eprint( obj[k])
        end
        str = str .. "}"
    end
    -- print array elements
    if #obj > 0 then
        str = str .. "["
        local first = true
        for _,v in ipairs( obj) do
            if not first then
                str = str .. ", "
            end
            first = false
            str = str .. PRINT.eprint( v)
        end
        str = str .. "]"
    end
    return str
end


PRINT.sprint = function( fmt, ...)
    local arg = {...}
    local str = fmt
    if #arg > 0 then
        str = string.format( fmt, PRINT.eprint( unpack( arg)))
    end
    return str
end


PRINT.pbuf = function( buf, start, length)
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


PRINT.strToBuf = function( str)
    local bytes = {}
    for idx = 1,#str do
        local chr = str:sub(idx, idx)
        local byte = string.byte( chr)
        table.insert( bytes, byte)
    end
    return bytes
end


return PRINT
