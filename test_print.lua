local luaunit = require( "luaunit")

local m_p = require( "print")


local TP = {}


function TP.test_sprint()
    local tab = { a=1, b=false, c=3, d={4, 5, 6}, e={z=123, x=true, y="FRED"}}
    tab[1] = 1.2345
    tab[2] = { 956, 123}
    luaunit.assertEquals( m_p.eprint( tab), '{a:1, b:false, c:3, d:[4, 5, 6], e:{x:true, y:"FRED", z:123}}[1.2345, [956, 123]]')
    luaunit.assertEquals( m_p.eprint( {}), "{}")
end

function TP.test_pbuf()
    local bytes = {0x00, 0x01, 0x02, 0x03, 0x04}
    luaunit.assertEquals( m_p.pbuf( bytes), "[0x00, 0x01, 0x02, 0x03, 0x04]")
    bytes = {}
    bytes[1] = 0x00
    bytes[2] = 0x01
    bytes[4] = 0x03
    bytes[5] = 0x04
    luaunit.assertEquals( m_p.pbuf( bytes), "[0x00, 0x01, nil, 0x03, 0x04]")
end


return TP
