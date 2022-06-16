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


return UTILS
