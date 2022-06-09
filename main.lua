
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
        for i,v in ipairs( obj) do
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


print( sprint( "hello"))
local tab = { a=1, b=2, c=3, d={4, 5, 6}, e={z=123, x=321, y="FRED"}}
tab[1] = 1.2345
tab[2] = { 956, 123}
print( sprint( "%s", tab))