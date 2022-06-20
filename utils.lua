-- utils


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

return UTILS
