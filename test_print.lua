local luaunit = require( "luaunit")

local m_p = require( "print")


local TP = {}


function TP.test_sprint()
    local tab = { a=1, b=2, c=3, d={4, 5, 6}, e={z=123, x=321, y="FRED"}}
    tab[1] = 1.2345
    tab[2] = { 956, 123}
    luaunit.assertEquals( m_p.eprint( tab), '{a:1, b:2, c:3, d:[4, 5, 6], e:{x:321, y:"FRED", z:123}}[1.2345, [956, 123]]')
    luaunit.assertEquals( m_p.eprint( {}), "{}")
end

function TP.test_pbuf()
    local bytes = {0x00, 0x01, 0x02, 0x03, 0x04}
    luaunit.assertEquals( m_p.pbuf( bytes), "[0x00, 0x01, 0x02, 0x03, 0x04]")
end


return TP
